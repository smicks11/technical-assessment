import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/amount_formatter.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static String _initials(String? name, String? email) {
    if (name != null && name.trim().length >= 2) {
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
      }
      return name.trim().length >= 2
          ? name.trim().substring(0, 2).toUpperCase()
          : (name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?');
    }
    if (email != null && email.trim().isNotEmpty) {
      final prefix = email.split('@').first;
      if (prefix.length >= 2) {
        return '${prefix[0].toUpperCase()}${prefix[1].toUpperCase()}';
      }
      return prefix.isNotEmpty ? prefix[0].toUpperCase() : '?';
    }
    return '?';
  }

  static String? _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final d = DateTime.tryParse(dateStr);
      if (d == null) return dateStr;
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: Consumer2<AuthController, HomeController>(
        builder: (context, auth, home, _) {
          final user = home.user ?? auth.user;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final balance = user.balance ?? 0.0;
          final currency = user.currency ?? 'NGN';
          final memberSince = _formatDate(user.createdAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.inputBackground,
                    child: Text(
                      _initials(user.name, user.email),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    user.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    user.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.subtitle,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Account number',
                  value: user.accountNumber ?? '—',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Balance',
                  value: '₦${formatAmount(balance)}',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Currency',
                  value: currency,
                  theme: theme,
                ),
                if (memberSince != null) ...[
                  const SizedBox(height: 16),
                  _DetailRow(
                    label: 'Member since',
                    value: memberSince,
                    theme: theme,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
