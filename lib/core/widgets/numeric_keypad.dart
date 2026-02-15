import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.keyHeight = 64,
  });

  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final double keyHeight;

  static const double _horizontalPadding = 24;
  static const double _keySpacing = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final keyWidth = (width - _horizontalPadding * 2 - _keySpacing * 2) / 3;
        final keySize = keyWidth.clamp(48.0, keyHeight * 1.4);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _key('1', keySize),
                  _key('2', keySize),
                  _key('3', keySize),
                ],
              ),
              SizedBox(height: keyHeight * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _key('4', keySize),
                  _key('5', keySize),
                  _key('6', keySize),
                ],
              ),
              SizedBox(height: keyHeight * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _key('7', keySize),
                  _key('8', keySize),
                  _key('9', keySize),
                ],
              ),
              SizedBox(height: keyHeight * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _biometricKey(keySize),
                  _key('0', keySize),
                  _backspaceKey(keySize),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _key(String digit, double keySize) {
    return SizedBox(
      width: keySize,
      height: keyHeight,
      child: Material(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(keyHeight * 0.4),
        child: InkWell(
          onTap: () => onDigit(digit),
          borderRadius: BorderRadius.circular(keyHeight * 0.4),
          child: Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _biometricKey(double keySize) {
    return SizedBox(
      width: keySize,
      height: keyHeight,
      child: Material(
        color: onBiometric != null ? AppColors.inputBackground : Colors.transparent,
        borderRadius: BorderRadius.circular(keyHeight * 0.4),
        child: InkWell(
          onTap: onBiometric,
          borderRadius: BorderRadius.circular(keyHeight * 0.4),
          child: Icon(
            Icons.fingerprint,
            size: 28,
            color: onBiometric != null ? AppColors.onSurface : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _backspaceKey(double keySize) {
    return SizedBox(
      width: keySize,
      height: keyHeight,
      child: Material(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(keyHeight * 0.4),
        child: InkWell(
          onTap: onBackspace,
          borderRadius: BorderRadius.circular(keyHeight * 0.4),
          child: Icon(
            Icons.close,
            size: 26,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
