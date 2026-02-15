import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final child = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
            ),
          )
        : Text(
            label,
            style: TextStyle(
              color: enabled ? AppColors.onPrimary : AppColors.buttonDisabledText,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.primary : AppColors.buttonDisabled,
        foregroundColor: enabled ? AppColors.onPrimary : AppColors.buttonDisabledText,
      ),
      child: child,
    );

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }
}
