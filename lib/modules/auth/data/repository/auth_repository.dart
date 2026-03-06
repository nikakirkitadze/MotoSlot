import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/storage/secure_storage_service.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/domain/model/app_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SecureStorageService _storageService;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required SecureStorageService storageService,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _storageService = storageService,
        _googleSignIn = googleSignIn;

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ── Email Link Auth ──────────────────────────────────────────

  Future<void> sendSignInLink(String email) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url:
            'https://a-eye-8c9a7.firebaseapp.com/emailSignIn?email=${Uri.encodeComponent(email.trim())}',
        handleCodeInApp: true,
        iOSBundleId: 'ge.motoslot.app',
        androidPackageName: 'ge.motoslot.app',
        androidInstallApp: true,
        androidMinimumVersion: '23',
      );

      await _firebaseAuth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: actionCodeSettings,
      );

      await _storageService.write('pending_email', email.trim());
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    } on FirebaseException catch (e) {
      developer.log('FirebaseException: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      developer.log('Unexpected error in sendSignInLink: ${e.runtimeType}: $e', name: 'AuthRepository');
      throw AuthException(
        message: 'Failed to send sign-in link: $e',
        originalError: e,
      );
    }
  }

  Future<AppUser> signInWithEmailLink(String emailLink) async {
    try {
      if (!_firebaseAuth.isSignInWithEmailLink(emailLink)) {
        throw const AuthException(message: 'Invalid sign-in link.');
      }

      final email = await _storageService.read('pending_email');
      if (email == null || email.isEmpty) {
        throw const AuthException(
            message: 'Email not found. Please enter your email again.');
      }

      final credential = await _firebaseAuth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(
            message: 'Sign in failed. Please try again.');
      }

      await _saveAuthTokens(user);
      await _storageService.delete('pending_email');

      return await _getOrCreateUserProfile(user, authProvider: 'email_link');
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException in signInWithEmailLink: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      developer.log('Unexpected error in signInWithEmailLink: ${e.runtimeType}: $e', name: 'AuthRepository');
      throw AuthException(
        message: 'Sign in failed: $e',
        originalError: e,
      );
    }
  }

  Future<String?> getPendingEmail() async {
    return await _storageService.read('pending_email');
  }

  // ── Google Sign-In ───────────────────────────────────────────

  Future<AppUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException(message: 'Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(
            message: 'Google sign-in failed. Please try again.');
      }

      await _saveAuthTokens(user);
      return await _getOrCreateUserProfile(user, authProvider: 'google');
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException in signInWithGoogle: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      developer.log('Unexpected error in signInWithGoogle: ${e.runtimeType}: $e', name: 'AuthRepository');
      throw AuthException(
        message: 'Google sign-in failed: $e',
        originalError: e,
      );
    }
  }

  // ── Apple Sign-In ────────────────────────────────────────────

  Future<AppUser> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(
            message: 'Apple sign-in failed. Please try again.');
      }

      // Apple only provides name on first sign-in
      final appleName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((n) => n != null && n.isNotEmpty).join(' ');

      if (appleName.isNotEmpty &&
          (user.displayName == null || user.displayName!.isEmpty)) {
        await user.updateDisplayName(appleName);
      }

      await _saveAuthTokens(user);
      return await _getOrCreateUserProfile(
        user,
        authProvider: 'apple',
        overrideDisplayName: appleName.isNotEmpty ? appleName : null,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      developer.log('SignInWithAppleAuthorizationException: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException(message: 'Apple sign-in was cancelled.');
      }
      throw AuthException(
        message: 'Apple sign-in failed. Please try again.',
        originalError: e,
      );
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException in signInWithApple: code=${e.code}, message=${e.message}', name: 'AuthRepository');
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      developer.log('Unexpected error in signInWithApple: ${e.runtimeType}: $e', name: 'AuthRepository');
      throw AuthException(
        message: 'Apple sign-in failed: $e',
        originalError: e,
      );
    }
  }

  // ── Profile Management ───────────────────────────────────────

  Future<AppUser> updateUserProfile({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    try {
      final docRef =
          _firestore.collection(AppConstants.usersCollection).doc(userId);
      final updates = <String, dynamic>{
        'fullName': fullName.trim(),
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
      };
      if (phone != null && phone.trim().isNotEmpty) {
        updates['phone'] = phone.trim();
      }

      await docRef.update(updates);
      await _firebaseAuth.currentUser?.updateDisplayName(fullName.trim());

      final doc = await docRef.get();
      return AppUser.fromJson(doc.data()!);
    } catch (e) {
      throw const AuthException(
          message: 'Failed to update profile. Please try again.');
    }
  }

  // ── Existing Methods ─────────────────────────────────────────

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _storageService.clearAll();
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      return await _getOrCreateUserProfile(firebaseUser,
          authProvider: 'unknown');
    } catch (_) {
      return null;
    }
  }

  Future<AppUser?> getUserById(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists || doc.data() == null) return null;
    return AppUser.fromJson(doc.data()!);
  }

  Future<List<AppUser>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'user')
        .get();

    final lowerQuery = query.toLowerCase();
    return snapshot.docs
        .map((doc) => AppUser.fromJson(doc.data()))
        .where((user) =>
            user.fullName.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            (user.phone?.contains(query) ?? false))
        .toList();
  }

  // ── Private Helpers ──────────────────────────────────────────

  Future<void> _saveAuthTokens(User user) async {
    final token = await user.getIdToken();
    if (token != null) {
      await _storageService.saveAuthToken(token);
    }
    await _storageService.saveUserId(user.uid);
  }

  Future<AppUser> _getOrCreateUserProfile(
    User user, {
    required String authProvider,
    String? overrideDisplayName,
  }) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final appUser = AppUser.fromJson(doc.data()!);
      await _storageService.saveUserRole(
        appUser.role == UserRole.admin ? 'admin' : 'user',
      );
      return appUser;
    }

    // Create new profile
    final displayName = overrideDisplayName ?? user.displayName ?? '';
    final appUser = AppUser(
      id: user.uid,
      email: user.email ?? '',
      fullName: displayName,
      phone: user.phoneNumber,
      role: UserRole.user,
      createdAt: DateTime.now().toUtc(),
      authProvider: authProvider,
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(appUser.toJson());

    await _storageService.saveUserRole('user');
    return appUser;
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      case 'invalid-action-code':
        return 'This sign-in link has expired or already been used.';
      case 'expired-action-code':
        return 'This sign-in link has expired. Please request a new one.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
