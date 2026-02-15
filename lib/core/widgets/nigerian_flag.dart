import 'package:flutter/material.dart';

class NigerianFlag extends StatelessWidget {
  const NigerianFlag({super.key, this.size = 24});

  final double size;

  static const Color _green = Color(0xFF008751);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: size * 1.5,
        height: size,
        child: Row(
          children: [
            Expanded(child: Container(color: _green)),
            Expanded(child: Container(color: Colors.white)),
            Expanded(child: Container(color: _green)),
          ],
        ),
      ),
    );
  }
}
