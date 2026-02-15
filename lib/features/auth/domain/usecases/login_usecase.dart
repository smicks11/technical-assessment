import '../../model/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call(String email, String password) =>
      _repository.login(email, password);
}
