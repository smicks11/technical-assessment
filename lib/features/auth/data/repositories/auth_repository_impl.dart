import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/app_exceptions.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../../model/login_response.dart';
import '../../model/register_request.dart';
import '../../model/user.dart';
import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._storage);

  final ApiService _api;
  final AuthStorageService _storage;

  @override
  Future<AuthStatus> checkAuthStatus() async {
    final token = await _storage.getToken();
    final email = await _storage.getStoredEmail();
    return AuthStatus(
      hasToken: token != null && token.isNotEmpty,
      storedEmail: email ?? '',
    );
  }

  @override
  Future<User> login(String email, String password) async {
    final data = await _api.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    if (data == null) throw AppException('Invalid response from server');
    final response = LoginResponse.fromJson(data);
    if (response.token.isEmpty) throw AppException('Invalid response from server');
    await _storage.saveToken(response.token);
    await _storage.saveStoredEmail(email.trim());
    return response.user;
  }

  @override
  Future<User?> register(RegisterRequest request) async {
    final data = await _api.post<Map<String, dynamic>>(
      ApiConstants.register,
      data: request.toJson(),
    );
    if (data == null) throw AppException('Invalid response from server');
    final response = LoginResponse.fromJson(data);
    if (response.token.isNotEmpty) {
      await _storage.saveToken(response.token);
      await _storage.saveStoredEmail(request.email.trim());
      return response.user;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post<dynamic>(ApiConstants.logout);
    } on AppException catch (_) {}
    await _storage.clearToken();
    await _storage.clearStoredEmail();
  }

  @override
  Future<User?> fetchUser() async {
    try {
      final data = await _api.get<Map<String, dynamic>>(ApiConstants.user);
      if (data == null) return null;
      final rawUser = data['user'];
      final userJson = rawUser is Map
          ? Map<String, dynamic>.from(rawUser)
          : data;
      return User.fromJson(userJson);
    } on UnauthorizedException catch (_) {
      await _storage.clearToken();
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _storage.clearToken();
    await _storage.clearStoredEmail();
  }
}
