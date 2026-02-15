import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/api_service.dart';
import '../services/auth_storage_service.dart';
import '../state/app_loading.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../routes/app_routes.dart';

List<SingleChildWidget> createAppProviders(
  AuthStorageService authStorage,
  GlobalKey<NavigatorState> navigatorKey,
) {
  final appLoading = AppLoading();
  final dio = ApiService.createDio();
  final apiService = ApiService(dio, authStorage);
  apiService.configureInterceptors();

  return [
    ChangeNotifierProvider<AppLoading>.value(value: appLoading),
    Provider<AuthStorageService>.value(value: authStorage),
    Provider<ApiService>.value(value: apiService),
    ChangeNotifierProvider<AuthController>(
      create: (context) {
        final auth = AuthController(apiService, authStorage, appLoading);
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
      create: (_) => HomeController(apiService, appLoading),
    ),
  ];
}
