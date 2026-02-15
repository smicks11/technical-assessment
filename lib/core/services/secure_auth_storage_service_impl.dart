import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_constants.dart';
import 'auth_storage_service.dart';

class SecureAuthStorageServiceImpl implements AuthStorageService {
  SecureAuthStorageServiceImpl({
    AndroidOptions? androidOptions,
    IOSOptions? iosOptions,
  }) : _storage = FlutterSecureStorage(
          aOptions: androidOptions ??
              const AndroidOptions(
                encryptedSharedPreferences: true,
              ),
          iOptions: iosOptions ?? IOSOptions(),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getToken() async {
    return _storage.read(key: StorageConstants.authToken);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageConstants.authToken, value: token);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: StorageConstants.authToken);
  }

  @override
  Future<String?> getStoredEmail() async {
    return _storage.read(key: StorageConstants.storedEmail);
  }

  @override
  Future<void> saveStoredEmail(String email) async {
    await _storage.write(key: StorageConstants.storedEmail, value: email);
  }

  @override
  Future<void> clearStoredEmail() async {
    await _storage.delete(key: StorageConstants.storedEmail);
  }
}
