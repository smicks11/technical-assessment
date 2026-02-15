import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pin_keypad_entry.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/validators.dart';
import '../controller/auth_controller.dart';

class LoginPasswordView extends StatefulWidget {
  const LoginPasswordView({super.key});

  @override
  State<LoginPasswordView> createState() => _LoginPasswordViewState();
}

class _LoginPasswordViewState extends State<LoginPasswordView> {
  String _enteredPin = '';
  int _keypadKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthController>().clearError();
    });
  }

  Future<void> _submit([String? pin]) async {
    final controller = context.read<AuthController>();
    final email = controller.storedEmail.trim();
    final password = pin ?? _enteredPin;
    if (email.isEmpty || !Validators.isSixDigitPin(password)) return;
    if (controller.isLoading) return;
    final success = await controller.login(email, password);
    if (success && mounted) {
      setState(() {
        _enteredPin = '';
        _keypadKey++;
      });
    } else if (mounted) {
      setState(() {
        _enteredPin = '';
        _keypadKey++;
      });
    }
  }

  void _goToFullLogin() {
    context.read<AuthController>().clearSession();
  }

  Future<void> _signOut() async {
    await context.read<AuthController>().logout();
  }

  String _displayName(String email) {
    if (email.isEmpty) return '';
    final prefix = email.split('@').first;
    if (prefix.isEmpty) return '';
    return prefix[0].toUpperCase() + prefix.substring(1).toLowerCase();
  }

  String _initials(String email) {
    if (email.isEmpty) return '?';
    final prefix = email.split('@').first;
    if (prefix.length >= 2) {
      return '${prefix[0].toUpperCase()}${prefix[1].toUpperCase()}';
    }
    return prefix.isNotEmpty ? prefix[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final responsive = responsiveHelperFromSize(size);
    final theme = Theme.of(context);
    final auth = context.watch<AuthController>();
    final storedEmail = auth.storedEmail.trim();
    final name = _displayName(storedEmail);

    if (storedEmail.isEmpty && auth.authChecked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _goToFullLogin();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.wp(5).clamp(20, 28),
                responsive.hp(2).clamp(16, 24),
                responsive.wp(5).clamp(20, 28),
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _goToFullLogin,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.inputBackground,
                      child: Text(
                        _initials(storedEmail),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.hp(2)),
                  Text(
                    name.isNotEmpty ? 'Welcome Back $name' : 'Welcome Back',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: responsive.hp(0.5)),
                  Text(
                    'Enter your 6-Digit PIN',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.hp(3)),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey(_keypadKey),
                child: PinKeypadEntry(
                  pinLength: 6,
                  keyHeight: 56,
                  squareBoxes: true,
                  onPinChanged: (pin) {
                    final wasComplete = _enteredPin.length == 6;
                    setState(() => _enteredPin = pin);
                    final justComplete =
                        !wasComplete && Validators.isSixDigitPin(pin);
                    if (justComplete &&
                        !auth.isLoading &&
                        auth.storedEmail.trim().isNotEmpty) {
                      _submit(pin);
                    }
                  },
                ),
              ),
            ),
            if (auth.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  auth.errorMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: responsive.hp(1.5)),
            Padding(
              padding: EdgeInsets.only(bottom: responsive.hp(3)),
              child: Center(
                child: GestureDetector(
                  onTap: auth.isLoading ? null : _signOut,
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitle,
                      ),
                      children: [
                        const TextSpan(text: 'Not your account? '),
                        TextSpan(
                          text: 'Log out',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.link,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.link,
                          ),
                        ),
                      ],
                    ),
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
