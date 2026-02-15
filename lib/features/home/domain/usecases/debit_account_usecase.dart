import '../repositories/user_repository.dart';

class DebitAccountUseCase {
  DebitAccountUseCase(this._repository);

  final UserRepository _repository;

  Future<void> call(double amount) => _repository.debit(amount);
}
