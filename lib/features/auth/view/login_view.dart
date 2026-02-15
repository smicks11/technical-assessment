import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = context.read<AuthController>().pendingLoginEmail;
      if (email.isNotEmpty) {
        _emailController.text = email;
        context.read<AuthController>().clearPendingLoginEmail();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return Validators.isValidEmail(_emailController.text) &&
        Validators.isSixDigitPin(_passwordController.text);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<AuthController>();
    final navigator = Navigator.of(context);
    final success = await controller.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (success && navigator.mounted) {
      navigator.pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final responsive = responsiveHelperFromSize(size);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: IconButton(
                  icon: const Icon(Icons.help_outline, color: AppColors.subtitle),
                  onPressed: () {},
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(8).clamp(24, 48),
                  vertical: responsive.hp(2),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: responsive.hp(4)),
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: responsive.hp(1)),
                      Text(
                        'Sign in to your account',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.subtitle,
                        ),
                      ),
                      SizedBox(height: responsive.hp(6)),
                      Consumer<AuthController>(
                        builder: (context, auth, _) {
                          if (auth.hasError) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                auth.errorMessage,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                  fontSize: responsive.sp(14),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        onChanged: (_) => context.read<AuthController>().clearError(),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '6 digits',
                        obscureText: true,
                        showObscureToggle: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        maxLength: Validators.pinLength,
                        validator: Validators.sixDigitPin,
                        onChanged: (_) => context.read<AuthController>().clearError(),
                      ),
                      SizedBox(height: responsive.hp(3)),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot password?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.link,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.hp(5)),
                      Consumer<AuthController>(
                        builder: (context, auth, _) => PrimaryButton(
                          label: 'Log In',
                          onPressed: (_canSubmit && !auth.isLoading) ? _submit : null,
                          isLoading: auth.isLoading,
                        ),
                      ),
                      SizedBox(height: responsive.hp(4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.subtitle,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(AppRoutes.register);
                            },
                            child: Text(
                              'Create Account',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.link,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
