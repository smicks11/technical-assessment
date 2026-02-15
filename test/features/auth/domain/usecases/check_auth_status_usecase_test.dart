import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/features/auth/domain/entities/auth_status.dart';
import 'package:technical_assesment/features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late CheckAuthStatusUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = CheckAuthStatusUseCase(mockRepo);
  });

  test('call returns AuthStatus from repository', () async {
    mockRepo.checkAuthStatusResult = const AuthStatus(
      hasToken: true,
      storedEmail: 'u@e.com',
    );

    final result = await useCase();

    expect(result.hasToken, true);
    expect(result.storedEmail, 'u@e.com');
  });

  test('call returns default when repository returns default', () async {
    final result = await useCase();

    expect(result.hasToken, false);
    expect(result.storedEmail, '');
  });
}
