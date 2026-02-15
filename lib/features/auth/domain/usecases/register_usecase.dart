import '../../model/register_request.dart';
import '../../model/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call(RegisterRequest request) => _repository.register(request);
}
