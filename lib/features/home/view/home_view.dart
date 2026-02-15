import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/error_widget_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/amount_formatter.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadUser();
    });
  }

  Future<void> _logout() async {
    await context.read<AuthController>().logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  Future<void> _showSendMoneyDialog(BuildContext context) async {
    final homeController = context.read<HomeController>();
    final messenger = ScaffoldMessenger.of(context);
    final amount = await AppDialog.showAmount(
      context,
      title: 'Send Money',
      label: 'Amount',
      hint: 'Enter amount',
    );
    if (amount == null || !mounted) return;
    final success = await homeController.credit(amount);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(success ? 'Success' : homeController.errorMessage),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  Future<void> _showAmountDialog(BuildContext context, bool isCredit) async {
    final homeController = context.read<HomeController>();
    final messenger = ScaffoldMessenger.of(context);
    final amount = await AppDialog.showAmount(
      context,
      title: isCredit ? 'Credit account' : 'Debit account',
      label: 'Amount',
      hint: 'Enter amount',
    );
    if (amount == null || !mounted) return;
    final success = isCredit
        ? await homeController.credit(amount)
        : await homeController.debit(amount);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(success ? 'Success' : homeController.errorMessage),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final responsive = responsiveHelperFromSize(size);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        title: Text(
          'Bank App',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.subtitle),
            onPressed: () {},
          ),
          Consumer<AuthController>(
            builder: (context, auth, _) => IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.onSurface, size: 22),
              onPressed: auth.isLoading ? null : _logout,
            ),
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.user == null) {
            return const LoadingIndicator();
          }
          if (controller.hasError && controller.user == null) {
            return ErrorWidgetView(
              message: controller.errorMessage,
              onRetry: () => controller.loadUser(),
            );
          }
          final user = controller.user ?? context.read<AuthController>().user;
          if (user == null) {
            return const LoadingIndicator();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(6).clamp(24, 48),
              vertical: responsive.hp(3).clamp(16, 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.errorMessage,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                  fontSize: responsive.sp(14),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.clearError,
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(2)),
                Text(
                  'Welcome Back, ${user.name.split(' ').first}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.hp(4)),
                Container(
                  padding: EdgeInsets.all(responsive.wp(5).clamp(20, 32)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.subtitle,
                        ),
                      ),
                      if (user.currency != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Currency: ${user.currency}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subtitle,
                          ),
                        ),
                      ],
                      if (user.balance != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Balance: ${formatAmount(user.balance!)}${user.currency != null ? ' ${user.currency}' : ''}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
                PrimaryButton(
                  label: 'Send Money',
                  onPressed: controller.creditDebitLoading
                      ? null
                      : () => _showSendMoneyDialog(context),
                  isExpanded: true,
                ),
                SizedBox(height: responsive.hp(2)),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Credit',
                        onPressed: controller.creditDebitLoading
                            ? null
                            : () => _showAmountDialog(context, true),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Debit',
                        onPressed: controller.creditDebitLoading
                            ? null
                            : () => _showAmountDialog(context, false),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
