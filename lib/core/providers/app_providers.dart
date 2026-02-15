import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/api_service.dart';
import '../services/auth_storage_service.dart';
import '../state/app_loading.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/clear_session_usecase.dart';
import '../../features/auth/domain/usecases/fetch_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/home/data/repositories/user_repository_impl.dart';
import '../../features/home/domain/repositories/user_repository.dart';
import '../../features/home/domain/usecases/credit_account_usecase.dart';
import '../../features/home/domain/usecases/debit_account_usecase.dart';
import '../../features/home/domain/usecases/get_user_usecase.dart';
import '../../routes/app_routes.dart';

List<SingleChildWidget> createAppProviders(
  AuthStorageService authStorage,
  GlobalKey<NavigatorState> navigatorKey,
) {
  final appLoading = AppLoading();
  final dio = ApiService.createDio();
  final apiService = ApiService(dio, authStorage);
  apiService.configureInterceptors();

  final AuthRepository authRepository =
      AuthRepositoryImpl(apiService, authStorage);
  final CheckAuthStatusUseCase checkAuthStatusUseCase =
      CheckAuthStatusUseCase(authRepository);
  final LoginUseCase loginUseCase = LoginUseCase(authRepository);
  final RegisterUseCase registerUseCase = RegisterUseCase(authRepository);
  final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository);
  final FetchUserUseCase fetchUserUseCase = FetchUserUseCase(authRepository);
  final ClearSessionUseCase clearSessionUseCase =
      ClearSessionUseCase(authRepository);

  final UserRepository userRepository = UserRepositoryImpl(apiService);
  final GetUserUseCase getUserUseCase = GetUserUseCase(userRepository);
  final CreditAccountUseCase creditAccountUseCase =
      CreditAccountUseCase(userRepository);
  final DebitAccountUseCase debitAccountUseCase =
      DebitAccountUseCase(userRepository);

  return [
    ChangeNotifierProvider<AppLoading>.value(value: appLoading),
    Provider<AuthStorageService>.value(value: authStorage),
    Provider<ApiService>.value(value: apiService),
    Provider<AuthRepository>.value(value: authRepository),
    Provider<UserRepository>.value(value: userRepository),
    ChangeNotifierProvider<AuthController>(
      create: (context) {
        final auth = AuthController(
          checkAuthStatusUseCase: checkAuthStatusUseCase,
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
          logoutUseCase: logoutUseCase,
          fetchUserUseCase: fetchUserUseCase,
          clearSessionUseCase: clearSessionUseCase,
          appLoading: appLoading,
        );
        apiService.setUnauthorizedCallback(() {
          auth.clearSession();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        });
        return auth;
      },
    ),
    ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(
        getUserUseCase: getUserUseCase,
        creditAccountUseCase: creditAccountUseCase,
        debitAccountUseCase: debitAccountUseCase,
        appLoading: appLoading,
      ),
    ),
  ];
}
