import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}
