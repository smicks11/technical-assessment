import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/usecases/register_usecase.dart';
import 'package:technical_assesment/features/auth/model/register_request.dart';
import 'package:technical_assesment/features/auth/model/user.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = RegisterUseCase(mockRepo);
  });

  test('call returns user when repository returns user', () async {
    final user = User(
      id: 1,
      name: 'Test',
      email: 'test@test.com',
    );
    mockRepo.registerResult = user;
    final request = RegisterRequest(
      name: 'Test',
      email: 'test@test.com',
      currency: 'NGN',
      password: '123456',
    );

    final result = await useCase(request);

    expect(result, user);
  });

  test('call returns null when repository returns null', () async {
    mockRepo.registerResult = null;
    final request = RegisterRequest(
      name: 'Test',
      email: 'test@test.com',
      currency: 'NGN',
      password: '123456',
    );

    final result = await useCase(request);

    expect(result, isNull);
  });

  test('call throws when repository throws', () async {
    mockRepo.registerThrow = Exception('fail');
    final request = RegisterRequest(
      name: 'Test',
      email: 'test@test.com',
      currency: 'NGN',
      password: '123456',
    );

    expect(() => useCase(request), throwsException);
  });
}
