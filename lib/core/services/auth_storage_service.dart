abstract class AuthStorageService {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<String?> getStoredEmail();
  Future<void> saveStoredEmail(String email);
  Future<void> clearStoredEmail();
}
