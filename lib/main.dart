import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/app_providers.dart';
import 'core/services/auth_storage_service.dart';
import 'core/state/app_loading.dart';
import 'core/services/secure_auth_storage_service_impl.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/auth_bootstrap.dart';
import 'core/widgets/top_loading_indicator.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view/login_password_view.dart';
import 'features/auth/view/register_view.dart';
import 'features/home/view/add_money_view.dart';
import 'features/home/view/dashboard_view.dart';
import 'features/home/view/debit_money_view.dart';
import 'features/home/view/profile_view.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authStorage = SecureAuthStorageServiceImpl();
  final navigatorKey = GlobalKey<NavigatorState>();
  runApp(BankApp(authStorage: authStorage, navigatorKey: navigatorKey));
}

class BankApp extends StatelessWidget {
  const BankApp({super.key, required this.authStorage, required this.navigatorKey});

  final AuthStorageService authStorage;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: createAppProviders(authStorage, navigatorKey),
      child: Consumer<AppLoading>(
        builder: (context, appLoading, child) {
          return Stack(
            textDirection: TextDirection.ltr,
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.translucent,
                child: child,
              ),
              TopLoadingIndicator(isLoading: appLoading.isLoading),
            ],
          );
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Bank',
          theme: AppTheme.light,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            return child;
          },
        initialRoute: AppRoutes.root,
        routes: {
          AppRoutes.root: (_) => const AuthBootstrap(),
          AppRoutes.login: (_) => const LoginView(),
          AppRoutes.loginPassword: (_) => const LoginPasswordView(),
          AppRoutes.register: (_) => const RegisterView(),
          AppRoutes.home: (_) => const DashboardView(),
          AppRoutes.addMoney: (_) => const AddMoneyView(),
          AppRoutes.debitMoney: (_) => const DebitMoneyView(),
          AppRoutes.profile: (_) => const ProfileView(),
        },
        ),
      ),
    );
  }
}
