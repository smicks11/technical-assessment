import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CardsPlaceholderView extends StatelessWidget {
  const CardsPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_rounded, size: 64, color: AppColors.subtitle),
            const SizedBox(height: 16),
            Text(
              'Cards',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
