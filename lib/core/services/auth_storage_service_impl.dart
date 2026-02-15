import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_constants.dart';
import 'auth_storage_service.dart';

class AuthStorageServiceImpl implements AuthStorageService {
  AuthStorageServiceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getToken() async {
    return _prefs.getString(StorageConstants.authToken);
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(StorageConstants.authToken, token);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(StorageConstants.authToken);
  }

  @override
  Future<String?> getStoredEmail() async {
    return _prefs.getString(StorageConstants.storedEmail);
  }

  @override
  Future<void> saveStoredEmail(String email) async {
    await _prefs.setString(StorageConstants.storedEmail, email);
  }

  @override
  Future<void> clearStoredEmail() async {
    await _prefs.remove(StorageConstants.storedEmail);
  }
}
