import 'package:flutter/foundation.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/app_exceptions.dart';
import '../../../core/state/app_loading.dart';
import '../../../core/constants/api_constants.dart';
import '../../auth/model/user.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._apiService, this._appLoading);

  final ApiService _apiService;
  final AppLoading _appLoading;

  User? _user;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _creditDebitLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get creditDebitLoading => _creditDebitLoading;

  Future<void> loadUser() async {
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

  Future<bool> credit(double amount) async {
    if (_creditDebitLoading) return false;
    if (amount <= 0) {
      _setError('Amount must be positive');
      notifyListeners();
      return false;
    }
    _setCreditDebitLoading(true);
    _appLoading.show();
    _clearError();
    try {
      await _apiService.post<Map<String, dynamic>>(
        ApiConstants.accountCredit,
        data: {'amount': amount},
      );
      if (_user != null) {
        final newBalance = (_user!.balance ?? 0) + amount;
        _user = _user!.copyWith(balance: newBalance);
        notifyListeners();
      }
      await loadUser();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Something went wrong. Please try again.');
      return false;
    } finally {
      _setCreditDebitLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  Future<bool> debit(double amount) async {
    if (_creditDebitLoading) return false;
    if (amount <= 0) {
      _setError('Amount must be positive');
      notifyListeners();
      return false;
    }
    final currentBalance = _user?.balance;
    if (currentBalance != null && amount > currentBalance) {
      _setError('Insufficient balance');
      notifyListeners();
      return false;
    }
    _setCreditDebitLoading(true);
    _appLoading.show();
    _clearError();
    try {
      await _apiService.post<Map<String, dynamic>>(
        ApiConstants.accountDebit,
        data: {'amount': amount},
      );
      if (_user != null) {
        final newBalance = (_user!.balance ?? 0) - amount;
        _user = _user!.copyWith(balance: newBalance);
        notifyListeners();
      }
      await loadUser();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Something went wrong. Please try again.');
      return false;
    } finally {
      _setCreditDebitLoading(false);
      _appLoading.hide();
      notifyListeners();
    }
  }

  void _setLoading(bool value) => _isLoading = value;
  void _setCreditDebitLoading(bool value) => _creditDebitLoading = value;

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
}
