import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/amount_formatter.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';

class DebitMoneyView extends StatefulWidget {
  const DebitMoneyView({super.key});

  @override
  State<DebitMoneyView> createState() => _DebitMoneyViewState();
}

class _DebitMoneyViewState extends State<DebitMoneyView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;
    final controller = context.read<HomeController>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final success = await controller.debit(amount);
    if (!mounted) return;
    if (success) {
      navigator.pop(true);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Withdrawal successful'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = responsiveHelperFromSize(MediaQuery.sizeOf(context));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        title: Text(
          'Withdraw',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<HomeController>(
          builder: (context, controller, _) {
            final user = controller.user ?? context.read<AuthController>().user;
            final balance = user?.balance ?? 0.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(6).clamp(24, 48),
                vertical: responsive.hp(3),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: responsive.hp(2)),
                    Text(
                      'Available balance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitle,
                      ),
                    ),
                    SizedBox(height: responsive.hp(0.5)),
                    Text(
                      '₦${formatAmount(balance)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: responsive.hp(5)),
                    AppTextField(
                      controller: _amountController,
                      label: 'Amount (₦)',
                      hint: 'Enter amount to withdraw',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final a = double.tryParse(v.trim());
                        if (a == null || a <= 0) return 'Enter a valid amount';
                        if (a > balance) return 'Insufficient balance';
                        return null;
                      },
                    ),
                    if (controller.hasError) ...[
                      SizedBox(height: responsive.hp(1.5)),
                      Text(
                        controller.errorMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    SizedBox(height: responsive.hp(4)),
                    PrimaryButton(
                      label: 'Withdraw',
                      onPressed: controller.creditDebitLoading ? null : _submit,
                      isLoading: controller.creditDebitLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
