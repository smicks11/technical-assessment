import 'package:flutter_test/flutter_test.dart';
import 'package:technical_assesment/core/utils/validators.dart';

void main() {
  group('required', () {
    test('returns null for non-empty string', () {
      expect(Validators.required('x'), isNull);
      expect(Validators.required('  a  '), isNull);
    });
    test('returns message for null or empty', () {
      expect(Validators.required(null), 'Required');
      expect(Validators.required(''), 'Required');
      expect(Validators.required('   '), 'Required');
    });
  });

  group('email', () {
    test('returns null for valid email', () {
      expect(Validators.email('a@b.com'), isNull);
    });
    test('returns message for missing @', () {
      expect(Validators.email('ab.com'), 'Invalid email');
    });
    test('returns Required for empty', () {
      expect(Validators.email(null), 'Required');
      expect(Validators.email(''), 'Required');
    });
  });

  group('sixDigitPin', () {
    test('returns null for 6 digits', () {
      expect(Validators.sixDigitPin('123456'), isNull);
    });
    test('returns message for wrong length or non-digits', () {
      expect(Validators.sixDigitPin('12345'), 'Must be 6 digits');
      expect(Validators.sixDigitPin('1234567'), 'Must be 6 digits');
      expect(Validators.sixDigitPin('12a456'), 'Must be 6 digits');
    });
    test('returns Required for empty', () {
      expect(Validators.sixDigitPin(null), 'Required');
      expect(Validators.sixDigitPin(''), 'Required');
    });
  });

  group('isValidEmail', () {
    test('returns true for non-empty string with @', () {
      expect(Validators.isValidEmail('a@b'), true);
    });
    test('returns false for empty or no @', () {
      expect(Validators.isValidEmail(''), false);
      expect(Validators.isValidEmail('ab'), false);
    });
  });

  group('isSixDigitPin', () {
    test('returns true for 6 digits', () {
      expect(Validators.isSixDigitPin('123456'), true);
    });
    test('returns false for non-6 or non-digits', () {
      expect(Validators.isSixDigitPin('12345'), false);
      expect(Validators.isSixDigitPin('1234567'), false);
      expect(Validators.isSixDigitPin('12a456'), false);
    });
  });

  test('pinLength is 6', () {
    expect(Validators.pinLength, 6);
  });
}
