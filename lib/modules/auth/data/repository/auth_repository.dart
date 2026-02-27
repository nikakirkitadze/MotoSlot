import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/storage/secure_storage_service.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/domain/model/app_user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SecureStorageService _storageService;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required SecureStorageService storageService,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _storageService = storageService;

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(message: 'Sign in failed. Please try again.');
      }

      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }
      await _storageService.saveUserId(user.uid);

      return await _getUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    }
  }

  Future<AppUser> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(message: 'Registration failed. Please try again.');
      }

      final appUser = AppUser(
        id: user.uid,
        email: email.trim(),
        fullName: fullName.trim(),
        phone: phone.trim(),
        role: UserRole.user,
        createdAt: DateTime.now().toUtc(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(appUser.toJson());

      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }
      await _storageService.saveUserId(user.uid);
      await _storageService.saveUserRole('user');

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
        originalError: e,
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _storageService.clearAll();
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      return await _getUserProfile(firebaseUser.uid);
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> _getUserProfile(String uid) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      // Auto-create profile for users that exist in Firebase Auth but not Firestore
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const AuthException(message: 'User profile not found.');
      }

      final appUser = AppUser(
        id: uid,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? '',
        phone: firebaseUser.phoneNumber ?? '',
        role: UserRole.user,
        createdAt: DateTime.now().toUtc(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(appUser.toJson());

      await _storageService.saveUserRole('user');
      return appUser;
    }

    final appUser = AppUser.fromJson(doc.data()!);
    await _storageService.saveUserRole(
      appUser.role == UserRole.admin ? 'admin' : 'user',
    );
    return appUser;
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
            user.phone.contains(query))
        .toList();
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
