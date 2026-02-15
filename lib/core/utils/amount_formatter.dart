String formatAmount(num value, {int decimalPlaces = 2}) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final str = absValue.toStringAsFixed(decimalPlaces);
  final parts = str.split('.');
  final intPart = parts[0];
  final decPart = parts.length > 1 ? parts[1] : '0'.padLeft(decimalPlaces, '0');
  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
    buffer.write(intPart[i]);
  }
  final result = decimalPlaces > 0 ? '$buffer.$decPart' : buffer.toString();
  return isNegative ? '-$result' : result;
}
