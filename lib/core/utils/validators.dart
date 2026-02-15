class Validators {
  Validators._();

  static const int pinLength = 6;
  static final RegExp _sixDigits = RegExp(r'^\d{6}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  static String? email(String? value) {
    final r = required(value);
    if (r != null) return r;
    if (!value!.trim().contains('@')) return 'Invalid email';
    return null;
  }

  static String? sixDigitPin(String? value) {
    final r = required(value);
    if (r != null) return r;
    if (value!.length != pinLength || !_sixDigits.hasMatch(value)) return 'Must be 6 digits';
    return null;
  }

  static bool isValidEmail(String value) {
    final t = value.trim();
    return t.isNotEmpty && t.contains('@');
  }

  static bool isSixDigitPin(String value) {
    return value.length == pinLength && _sixDigits.hasMatch(value);
  }
}
