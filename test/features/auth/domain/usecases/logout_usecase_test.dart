import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/usecases/logout_usecase.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = LogoutUseCase(mockRepo);
  });

  test('call completes without throwing', () async {
    await expectLater(useCase(), completes);
  });
}
