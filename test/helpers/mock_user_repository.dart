import 'package:technical_assesment/features/auth/model/user.dart';
import 'package:technical_assesment/features/home/domain/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  User? getUserResult;
  Exception? getUserThrow;
  Exception? creditThrow;
  Exception? debitThrow;

  @override
  Future<User?> getUser() async {
    if (getUserThrow != null) throw getUserThrow!;
    return getUserResult;
  }

  @override
  Future<void> credit(double amount) async {
    if (creditThrow != null) throw creditThrow!;
  }

  @override
  Future<void> debit(double amount) async {
    if (debitThrow != null) throw debitThrow!;
  }
}
