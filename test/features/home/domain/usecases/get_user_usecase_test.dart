import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/model/user.dart';
import 'package:technical_assesment/features/home/domain/usecases/get_user_usecase.dart';
import '../../../../helpers/mock_user_repository.dart';

void main() {
  late MockUserRepository mockRepo;
  late GetUserUseCase useCase;

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = GetUserUseCase(mockRepo);
  });

  test('call returns user when repository returns user', () async {
    final user = User(
      id: 1,
      name: 'Test',
      email: 'test@test.com',
    );
    mockRepo.getUserResult = user;

    final result = await useCase();

    expect(result, user);
  });

  test('call returns null when repository returns null', () async {
    mockRepo.getUserResult = null;

    final result = await useCase();

    expect(result, isNull);
  });

  test('call throws when repository throws', () async {
    mockRepo.getUserThrow = Exception('fail');

    expect(() => useCase(), throwsException);
  });
}
