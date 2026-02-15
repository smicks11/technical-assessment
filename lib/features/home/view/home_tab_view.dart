import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/error_widget_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/nigerian_flag.dart';
import '../../../core/utils/amount_formatter.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  bool _balanceVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = responsiveHelperFromSize(MediaQuery.sizeOf(context));
    final theme = Theme.of(context);

    return Consumer<HomeController>(
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

        final balance = user.balance ?? 0.0;
        final balanceStr = _balanceVisible
            ? '₦${formatAmount(balance)}'
            : '₦••••••';

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5).clamp(20, 28),
                    vertical: responsive.hp(2).clamp(12, 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(context, theme, user),
                      SizedBox(height: responsive.hp(2)),
                      _buildMainCard(
                        theme,
                        responsive,
                        balanceStr,
                        user,
                        controller,
                      ),
                      SizedBox(height: responsive.hp(2.5)),
                      _buildPromoBanner(theme, responsive),
                      SizedBox(height: responsive.hp(2.5)),
                      _buildRecommendedHeader(theme),
                      SizedBox(height: responsive.hp(1.5)),
                      _buildRecommendedCards(theme, responsive),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme, dynamic user) {
    final initials = user.name.isNotEmpty
        ? user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : '?';
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.inputBackground,
          child: Text(
            initials,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          _formatTime(DateTime.now()),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.subtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Earn ₦5',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(
    ThemeData theme,
    dynamic responsive,
    String balanceStr,
    dynamic user,
    HomeController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(5).clamp(20, 28)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const NigerianFlag(size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Nigerian Naira',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.subtitle, size: 24),
            ],
          ),
          SizedBox(height: responsive.hp(1.5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                balanceStr,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                child: Icon(
                  _balanceVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22,
                  color: AppColors.subtitle,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.hp(2)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '•••••••• ${user.id.toString().padLeft(4, '0')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.subtitle),
              ],
            ),
          ),
          SizedBox(height: responsive.hp(2.5)),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.add_rounded,
                  label: 'Add Money',
                  onTap: controller.creditDebitLoading
                      ? null
                      : () => Navigator.of(context).pushNamed(AppRoutes.addMoney),
                ),
              ),
              SizedBox(width: responsive.wp(4)),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Send',
                  onTap: controller.creditDebitLoading
                      ? null
                      : () => Navigator.of(context).pushNamed(AppRoutes.debitMoney),
                ),
              ),
              SizedBox(width: responsive.wp(4)),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.remove_rounded,
                  label: 'Withdraw',
                  onTap: controller.creditDebitLoading
                      ? null
                      : () => Navigator.of(context).pushNamed(AppRoutes.debitMoney),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(ThemeData theme, dynamic responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.wp(5).clamp(20, 28)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A7B4A),
            const Color(0xFF0A7B4A).withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A7B4A).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Naira anywhere, anytime',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.debitMoney),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Text(
                        'Try now →',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF0A7B4A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const NigerianFlag(size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedHeader(ThemeData theme) {
    return Text(
      'Recommended',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
    );
  }

  Widget _buildRecommendedCards(ThemeData theme, dynamic responsive) {
    return Row(
      children: [
        Expanded(
          child: _RecommendedCard(
            label: 'Bills & Airtime',
            icon: Icons.receipt_long_rounded,
            onTap: () {},
          ),
        ),
        SizedBox(width: responsive.wp(3)),
        Expanded(
          child: _RecommendedCard(
            label: 'Invoices',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime d) {
    final h = d.hour;
    final m = d.minute;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.inputBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColors.onSurface),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.inputBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.subtitle, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
