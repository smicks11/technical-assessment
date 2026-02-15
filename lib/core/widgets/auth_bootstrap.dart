import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_indicator.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/login_password_view.dart';
import '../../features/home/view/dashboard_view.dart';

class AuthBootstrap extends StatefulWidget {
  const AuthBootstrap({super.key});

  @override
  State<AuthBootstrap> createState() => _AuthBootstrapState();
}

class _AuthBootstrapState extends State<AuthBootstrap>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().checkAuthStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      context.read<AuthController>().lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        if (!auth.authChecked) {
          return const Scaffold(body: LoadingIndicator());
        }
        if (!auth.hasToken) {
          return const LoginView();
        }
        if (auth.hasToken && auth.isAppLocked) {
          return const LoginPasswordView();
        }
        if (auth.hasToken && !auth.isAppLocked && auth.user == null && !auth.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthController>().fetchUser();
          });
          return const Scaffold(body: LoadingIndicator());
        }
        return const DashboardView();
      },
    );
  }
}
