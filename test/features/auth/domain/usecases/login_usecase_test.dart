import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/usecases/login_usecase.dart';
import 'package:technical_assesment/features/auth/model/user.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late LoginUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = LoginUseCase(mockRepo);
  });

  test('call returns user from repository', () async {
    final user = User(
      id: 1,
      name: 'Test',
      email: 'test@test.com',
    );
    mockRepo.loginResult = user;

    final result = await useCase('a@b.com', '123456');

    expect(result, user);
  });

  test('call throws when repository throws', () async {
    mockRepo.loginThrow = Exception('fail');

    expect(() => useCase('a@b.com', '123456'), throwsException);
  });
}
