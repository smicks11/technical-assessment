import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/home/domain/usecases/credit_account_usecase.dart';
import '../../../../helpers/mock_user_repository.dart';

void main() {
  late MockUserRepository mockRepo;
  late CreditAccountUseCase useCase;

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = CreditAccountUseCase(mockRepo);
  });

  test('call completes when repository succeeds', () async {
    await expectLater(useCase(100), completes);
  });

  test('call throws when repository throws', () async {
    mockRepo.creditThrow = Exception('fail');

    expect(() => useCase(100), throwsException);
  });
}
