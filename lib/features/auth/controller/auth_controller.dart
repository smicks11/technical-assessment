import 'package:flutter/foundation.dart';

import '../../../core/services/app_exceptions.dart';
import '../../../core/state/app_loading.dart';
import '../domain/usecases/check_auth_status_usecase.dart';
import '../domain/usecases/clear_session_usecase.dart';
import '../domain/usecases/fetch_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../model/register_request.dart';
import '../model/user.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required FetchUserUseCase fetchUserUseCase,
    required ClearSessionUseCase clearSessionUseCase,
    required AppLoading appLoading,
  })  : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _fetchUserUseCase = fetchUserUseCase,
        _clearSessionUseCase = clearSessionUseCase,
        _appLoading = appLoading;

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final FetchUserUseCase _fetchUserUseCase;
  final ClearSessionUseCase _clearSessionUseCase;
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
    final status = await _checkAuthStatusUseCase();
    _hasToken = status.hasToken;
    _storedEmail = status.storedEmail;
    if (!status.hasToken) {
      _user = null;
      _isAppLocked = false;
    } else {
      _isAppLocked = true;
      _user = null;
    }
    _authChecked = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;
    _setLoading(true);
    _appLoading.show();
    _clearError();
    try {
      final user = await _loginUseCase(email, password);
      _user = user;
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
      final user = await _registerUseCase(request);
      if (user != null) {
        _user = user;
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
      await _logoutUseCase();
    } finally {
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
      final user = await _fetchUserUseCase();
      _user = user;
      notifyListeners();
    } on AppException catch (e) {
      _setError(e.message);
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
    await _clearSessionUseCase();
    _user = null;
    _hasToken = false;
    _isAppLocked = false;
    _storedEmail = '';
    _authChecked = true;
    notifyListeners();
  }
}
