import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PinInputDisplay extends StatelessWidget {
  const PinInputDisplay({
    super.key,
    required this.length,
    required this.enteredLength,
    this.filledColor,
    this.emptyColor,
    this.size = 16,
    this.spacing = 16,
    this.square = false,
  });

  final int length;
  final int enteredLength;
  final Color? filledColor;
  final Color? emptyColor;
  final double size;
  final double spacing;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final filled = filledColor ?? AppColors.primary;
    final empty = emptyColor ?? AppColors.outline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(length, (i) {
        final isFilled = i < enteredLength;
        return Padding(
          padding: EdgeInsets.only(right: i < length - 1 ? spacing : 0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: square ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: square ? BorderRadius.circular(8) : null,
              color: square ? Colors.white : (isFilled ? filled : Colors.transparent),
              border: Border.all(
                color: isFilled ? filled : empty,
                width: square ? 1.5 : 2,
              ),
            ),
            child: isFilled
                ? Center(
                    child: Container(
                      width: square ? size * 0.25 : size * 0.5,
                      height: square ? size * 0.25 : size * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled,
                      ),
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }
}
