import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  // Cached tokens in memory
  String? _accessToken;
  String? _userId;
  String? _userRole;

  Future<void> storeAccessToken(String accessToken) async {
    await Future.wait([_secureStorage.delete(key: _accessTokenKey)]);
    _accessToken = accessToken;
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> storeUserIdAndTokens({
    required String accessToken,
    required String userId,
  }) async => Future.wait([storeAccessToken(accessToken), storeUserId(userId)]);

  Future<void> storeUserId(String userId) async {
    await _secureStorage.delete(key: _userIdKey);
    _userId = userId;
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  Future<void> storeUserRole(String userRole) async {
    await _secureStorage.delete(key: _userRoleKey);
    _userRole = userRole;
    await _secureStorage.write(key: _userRoleKey, value: userRole);
  }

  Future<String?> getUserId() async =>
      _userId ?? await _secureStorage.read(key: _userIdKey);

  Future<String?> getAccessToken() async =>
      _accessToken ?? await _secureStorage.read(key: _accessTokenKey);

  Future<String?> getUserRole() async =>
      _userRole ?? await _secureStorage.read(key: _userRoleKey);

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
    _accessToken = null;
    _userId = null;
    _userRole = null;
  }
}
