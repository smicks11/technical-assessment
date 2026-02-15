import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/usecases/fetch_user_usecase.dart';
import 'package:technical_assesment/features/auth/model/user.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late FetchUserUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = FetchUserUseCase(mockRepo);
  });

  test('call returns user when repository returns user', () async {
    final user = User(
      id: 1,
      name: 'Test',
      email: 'test@test.com',
    );
    mockRepo.fetchUserResult = user;

    final result = await useCase();

    expect(result, user);
  });

  test('call returns null when repository returns null', () async {
    mockRepo.fetchUserResult = null;

    final result = await useCase();

    expect(result, isNull);
  });

  test('call throws when repository throws', () async {
    mockRepo.fetchUserThrow = Exception('fail');

    expect(() => useCase(), throwsException);
  });
}
