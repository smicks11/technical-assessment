import '../repositories/auth_repository.dart';

class ClearSessionUseCase {
  ClearSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}
