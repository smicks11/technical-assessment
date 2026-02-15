import '../../../auth/model/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  GetUserUseCase(this._repository);

  final UserRepository _repository;

  Future<User?> call() => _repository.getUser();
}
