import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class MorePlaceholderView extends StatelessWidget {
  const MorePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'More',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.person_outline_rounded, color: AppColors.subtitle),
                    title: Text(
                      'Profile & account details',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: AppColors.subtitle),
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: AppColors.subtitle),
                    title: Text(
                      'Help',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: AppColors.subtitle),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: AppColors.subtitle),
                    title: Text(
                      'Settings',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: AppColors.subtitle),
                    onTap: () {},
                  ),
                  const Divider(height: 32),
                  Consumer<AuthController>(
                    builder: (context, auth, _) => ListTile(
                      leading: Icon(Icons.logout_rounded, color: AppColors.error),
                      title: Text(
                        'Sign out',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: auth.isLoading
                          ? null
                          : () async {
                              await auth.logout();
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
