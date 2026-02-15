import '../entities/auth_status.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  CheckAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthStatus> call() => _repository.checkAuthStatus();
}
