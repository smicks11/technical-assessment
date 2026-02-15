import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/usecases/clear_session_usecase.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late ClearSessionUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = ClearSessionUseCase(mockRepo);
  });

  test('call completes without throwing', () async {
    await expectLater(useCase(), completes);
  });
}
