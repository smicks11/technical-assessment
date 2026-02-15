import '../../model/register_request.dart';
import '../entities/auth_status.dart';
import '../../model/user.dart';

abstract class AuthRepository {
  Future<AuthStatus> checkAuthStatus();
  Future<User> login(String email, String password);
  Future<User?> register(RegisterRequest request);
  Future<void> logout();
  Future<User?> fetchUser();
  Future<void> clearSession();
}
