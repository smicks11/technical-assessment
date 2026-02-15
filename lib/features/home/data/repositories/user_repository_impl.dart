import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../auth/model/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);

  final ApiService _api;

  @override
  Future<User?> getUser() async {
    final data = await _api.get<Map<String, dynamic>>(ApiConstants.user);
    if (data == null) return null;
    final rawUser = data['user'];
    final userJson = rawUser is Map
        ? Map<String, dynamic>.from(rawUser)
        : data;
    return User.fromJson(userJson);
  }

  @override
  Future<void> credit(double amount) async {
    await _api.post<Map<String, dynamic>>(
      ApiConstants.accountCredit,
      data: {'amount': amount},
    );
  }

  @override
  Future<void> debit(double amount) async {
    await _api.post<Map<String, dynamic>>(
      ApiConstants.accountDebit,
      data: {'amount': amount},
    );
  }
}
