import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/core/utils/amount_formatter.dart';

void main() {
  test('formats positive number with commas and 2 decimals', () {
    expect(formatAmount(1234.5), '1,234.50');
    expect(formatAmount(1000000), '1,000,000.00');
    expect(formatAmount(0), '0.00');
  });

  test('formats negative number with minus', () {
    expect(formatAmount(-100.5), '-100.50');
  });

  test('respects decimalPlaces', () {
    expect(formatAmount(1.234, decimalPlaces: 0), '1');
    expect(formatAmount(1.2, decimalPlaces: 3), '1.200');
  });
}
