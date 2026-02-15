import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/home/domain/usecases/debit_account_usecase.dart';
import '../../../../helpers/mock_user_repository.dart';

void main() {
  late MockUserRepository mockRepo;
  late DebitAccountUseCase useCase;

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = DebitAccountUseCase(mockRepo);
  });

  test('call completes when repository succeeds', () async {
    await expectLater(useCase(50), completes);
  });

  test('call throws when repository throws', () async {
    mockRepo.debitThrow = Exception('fail');

    expect(() => useCase(50), throwsException);
  });
}
