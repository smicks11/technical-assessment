import 'dart:ui';

class ResponsiveHelper {
  ResponsiveHelper(this._width, this._height);

  final double _width;
  final double _height;

  static const double _refWidth = 375;

  double wp(num percentage) => _width * (percentage.toDouble() / 100);

  double hp(num percentage) => _height * (percentage.toDouble() / 100);

  double sp(num size) {
    final scale = (_width / _refWidth).clamp(0.8, 1.2);
    return (size * scale).toDouble();
  }

  double get width => _width;
  double get height => _height;

  bool get isSmallScreen => _width < 600;
  bool get isMediumScreen => _width >= 600 && _width < 900;
  bool get isLargeScreen => _width >= 900;
}

ResponsiveHelper responsiveHelperFromSize(Size size) {
  return ResponsiveHelper(size.width, size.height);
}
