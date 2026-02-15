import '../../../auth/model/user.dart';

abstract class UserRepository {
  Future<User?> getUser();
  Future<void> credit(double amount);
  Future<void> debit(double amount);
}
