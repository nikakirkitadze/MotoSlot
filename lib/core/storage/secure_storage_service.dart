import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _authTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _userRoleKey = 'user_role';

  // Auth token
  Future<void> saveAuthToken(String token) =>
      _storage.write(key: _authTokenKey, value: token);

  Future<String?> getAuthToken() => _storage.read(key: _authTokenKey);

  Future<void> deleteAuthToken() => _storage.delete(key: _authTokenKey);

  // Refresh token
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  // User ID
  Future<void> saveUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);

  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  // User role
  Future<void> saveUserRole(String role) =>
      _storage.write(key: _userRoleKey, value: role);

  Future<String?> getUserRole() => _storage.read(key: _userRoleKey);

  // Clear all
  Future<void> clearAll() => _storage.deleteAll();

  // Generic
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  FlutterSecureStorage get rawStorage => _storage;
}
