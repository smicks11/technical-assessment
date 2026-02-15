import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';
import '../model/register_request.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currencyController = TextEditingController(text: 'XAF');
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currencyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<AuthController>();
    final navigator = Navigator.of(context);
    final request = RegisterRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      currency: _currencyController.text.trim(),
      password: _passwordController.text,
    );
    final success = await controller.register(request);
    if (success && navigator.mounted) {
      final auth = context.read<AuthController>();
      if (auth.hasToken) {
        navigator.pushReplacementNamed(AppRoutes.home);
      } else {
        controller.setPendingLoginEmail(_emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created. Please sign in.'),
            backgroundColor: AppColors.primary,
          ),
        );
        navigator.pushReplacementNamed(AppRoutes.login);
      }
    }
  }

  bool get _canSubmit {
    return Validators.required(_nameController.text.trim()) == null &&
        Validators.isValidEmail(_emailController.text) &&
        Validators.required(_currencyController.text.trim()) == null &&
        Validators.isSixDigitPin(_passwordController.text);
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
                      SizedBox(height: responsive.hp(2)),
                      Text(
                        'Create Account',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: responsive.hp(1)),
                      Text(
                        'Sign up for banking',
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
                        controller: _nameController,
                        label: 'Full name',
                        hint: 'Enter your name',
                        textInputAction: TextInputAction.next,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: responsive.hp(2)),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        onChanged: (_) {
                          setState(() {});
                          context.read<AuthController>().clearError();
                        },
                      ),
                      SizedBox(height: responsive.hp(2)),
                      AppTextField(
                        controller: _currencyController,
                        label: 'Currency',
                        hint: 'e.g. XAF, USD',
                        textInputAction: TextInputAction.next,
                        validator: Validators.required,
                        onChanged: (_) => setState(() {}),
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
                        onChanged: (_) {
                          setState(() {});
                          context.read<AuthController>().clearError();
                        },
                      ),
                      SizedBox(height: responsive.hp(5)),
                      Consumer<AuthController>(
                        builder: (context, auth, _) => PrimaryButton(
                          label: 'Register',
                          onPressed: (_canSubmit && !auth.isLoading) ? _submit : null,
                          isLoading: auth.isLoading,
                        ),
                      ),
                      SizedBox(height: responsive.hp(4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.subtitle,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                            },
                            child: Text(
                              'Sign in',
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
