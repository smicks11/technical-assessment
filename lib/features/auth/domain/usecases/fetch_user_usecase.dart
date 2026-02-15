import '../../model/user.dart';
import '../repositories/auth_repository.dart';

class FetchUserUseCase {
  FetchUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() => _repository.fetchUser();
}
