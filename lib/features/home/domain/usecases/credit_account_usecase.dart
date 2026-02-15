import '../repositories/user_repository.dart';

class CreditAccountUseCase {
  CreditAccountUseCase(this._repository);

  final UserRepository _repository;

  Future<void> call(double amount) => _repository.credit(amount);
}
