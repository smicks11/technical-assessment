import 'package:technical_assesment/features/auth/domain/entities/auth_status.dart';
import 'package:technical_assesment/features/auth/domain/repositories/auth_repository.dart';
import 'package:technical_assesment/features/auth/model/register_request.dart';
import 'package:technical_assesment/features/auth/model/user.dart';

class MockAuthRepository implements AuthRepository {
  AuthStatus? checkAuthStatusResult;
  User? loginResult;
  Exception? loginThrow;
  User? registerResult;
  Exception? registerThrow;
  Exception? fetchUserThrow;
  User? fetchUserResult;

  @override
  Future<AuthStatus> checkAuthStatus() async {
    return checkAuthStatusResult ?? const AuthStatus(hasToken: false, storedEmail: '');
  }

  @override
  Future<User> login(String email, String password) async {
    if (loginThrow != null) throw loginThrow!;
    if (loginResult != null) return loginResult!;
    throw StateError('loginResult not set');
  }

  @override
  Future<User?> register(RegisterRequest request) async {
    if (registerThrow != null) throw registerThrow!;
    return registerResult;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User?> fetchUser() async {
    if (fetchUserThrow != null) throw fetchUserThrow!;
    return fetchUserResult;
  }

  @override
  Future<void> clearSession() async {}
}
