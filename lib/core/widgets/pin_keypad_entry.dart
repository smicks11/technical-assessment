import 'package:flutter/material.dart';

import 'numeric_keypad.dart';
import 'pin_input_display.dart';

class PinKeypadEntry extends StatefulWidget {
  const PinKeypadEntry({
    super.key,
    this.pinLength = 6,
    this.keyHeight = 56,
    this.onPinChanged,
    this.onBiometric,
    this.squareBoxes = false,
  });

  final int pinLength;
  final double keyHeight;
  final void Function(String pin)? onPinChanged;
  final VoidCallback? onBiometric;
  final bool squareBoxes;

  @override
  State<PinKeypadEntry> createState() => _PinKeypadEntryState();
}

class _PinKeypadEntryState extends State<PinKeypadEntry> {
  final List<String> _digits = [];

  void _onDigit(String digit) {
    if (_digits.length >= widget.pinLength) return;
    setState(() {
      _digits.add(digit);
      final pin = _digits.join();
      widget.onPinChanged?.call(pin);
    });
  }

  void _onBackspace() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      widget.onPinChanged?.call(_digits.join());
    });
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 24;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: PinInputDisplay(
            length: widget.pinLength,
            enteredLength: _digits.length,
            size: widget.squareBoxes ? 48 : 16,
            spacing: widget.squareBoxes ? 12 : 20,
            square: widget.squareBoxes,
          ),
        ),
        SizedBox(height: widget.keyHeight * 0.8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NumericKeypad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onBiometric: widget.onBiometric,
                keyHeight: widget.keyHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
