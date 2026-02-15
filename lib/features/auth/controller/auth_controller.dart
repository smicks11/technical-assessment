import 'package:flutter/foundation.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/app_exceptions.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../../core/state/app_loading.dart';
import '../../../core/constants/api_constants.dart';
import '../model/login_response.dart';
import '../model/register_request.dart';
import '../model/user.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._apiService, this._authStorage, this._appLoading);

  final ApiService _apiService;
  final AuthStorageService _authStorage;
  final AppLoading _appLoading;

  User? _user;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _authChecked = false;
  String _pendingLoginEmail = '';
  bool _hasToken = false;
  bool _isAppLocked = true;
  String _storedEmail = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get authChecked => _authChecked;
  String get pendingLoginEmail => _pendingLoginEmail;
  bool get hasToken => _hasToken;
  bool get isAppLocked => _isAppLocked;
  String get storedEmail => _storedEmail;

  void lock() {
    _isAppLocked = true;
    _user = null;
    notifyListeners();
  }

  void unlock() {
    _isAppLocked = false;
    notifyListeners();
  }

  void setPendingLoginEmail(String email) {
    _pendingLoginEmail = email.trim();
    notifyListeners();
  }

  void clearPendingLoginEmail() {
    _pendingLoginEmail = '';
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authStorage.getToken();
    final email = await _authStorage.getStoredEmail();
    if (token == null || token.isEmpty) {
      _user = null;
      _hasToken = false;
      _isAppLocked = false;
      _storedEmail = email ?? '';
      _authChecked = true;
      notifyListeners();
      return;
    }
    _hasToken = true;
    _isAppLocked = true;
    _user = null;
    _storedEmail = email ?? '';
    _authChecked = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;
    _setLoading(true);
    _appLoading.show();
    _clearError();
    try {
      final data = await _apiService.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      if (data == null) {
        _setError('Invalid response from server');
        return false;
      }
      final response = LoginResponse.fromJson(data);
      if (response.token.isEmpty) {
        _setError('Invalid response from server');
        return false;
      }
      await _authStorage.saveToken(response.token);
      await _authStorage.saveStoredEmail(email.trim());
      _user = response.user;
      _hasToken = true;
      _isAppLocked = false;
      _storedEmail = email.trim();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Invalid response from server');
      return false;
    } finally {
      _setLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    if (_isLoading) return false;
    _setLoading(true);
    _appLoading.show();
    _clearError();
    try {
      final data = await _apiService.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: request.toJson(),
      );
      if (data == null) {
        _setError('Invalid response from server');
        return false;
      }
      final response = LoginResponse.fromJson(data);
      if (response.token.isNotEmpty) {
        await _authStorage.saveToken(response.token);
        await _authStorage.saveStoredEmail(request.email.trim());
        _user = response.user;
        _hasToken = true;
        _isAppLocked = false;
        _storedEmail = request.email.trim();
      }
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Invalid response from server');
      return false;
    } finally {
      _setLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _appLoading.show();
    _clearError();
    try {
      await _apiService.post<dynamic>(ApiConstants.logout);
    } on AppException catch (_) {
    } finally {
      await _authStorage.clearToken();
      await _authStorage.clearStoredEmail();
      _user = null;
      _hasToken = false;
      _isAppLocked = false;
      _storedEmail = '';
      _setLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  Future<void> fetchUser() async {
    _setLoading(true);
    _appLoading.show();
    _clearError();
    try {
      final data = await _apiService.get<Map<String, dynamic>>(ApiConstants.user);
      if (data == null) {
        return;
      }
      final rawUser = data['user'];
      final userJson = rawUser is Map
          ? Map<String, dynamic>.from(rawUser)
          : data;
      _user = User.fromJson(userJson);
      notifyListeners();
    } on AppException catch (e) {
      if (e is UnauthorizedException) {
        await _authStorage.clearToken();
        _user = null;
      } else {
        _setError(e.message);
      }
      notifyListeners();
    } catch (_) {
      _setError('Invalid response from server');
      notifyListeners();
    } finally {
      _setLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = '';
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _authStorage.clearToken();
    await _authStorage.clearStoredEmail();
    _user = null;
    _hasToken = false;
    _isAppLocked = false;
    _storedEmail = '';
    _authChecked = true;
    notifyListeners();
  }
}
