import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../state/app_loading.dart';

class TopLoadingIndicator extends StatelessWidget {
  const TopLoadingIndicator({super.key, this.isLoading});

  final bool? isLoading;

  static const double _height = 4.0;

  @override
  Widget build(BuildContext context) {
    final loading = isLoading ?? context.watch<AppLoading>().isLoading;

    if (!loading) return const SizedBox.shrink();

    final top = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: IgnorePointer(
          child: Padding(
            padding: EdgeInsets.only(top: top),
            child: SizedBox(
              height: _height,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.primary.withValues(alpha: 0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: _height,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
