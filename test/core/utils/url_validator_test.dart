import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/utils/url_validator.dart';

void main() {
  group('isValidHttpUrl', () {
    test('accepts http and https urls with host', () {
      expect(isValidHttpUrl('http://example.com'), isTrue);
      expect(isValidHttpUrl('https://example.com/path?x=1'), isTrue);
    });

    test('rejects empty or whitespace-only strings', () {
      expect(isValidHttpUrl(''), isFalse);
      expect(isValidHttpUrl('   '), isFalse);
    });

    test('rejects non-http schemes and hostless urls', () {
      expect(isValidHttpUrl('ftp://example.com'), isFalse);
      expect(isValidHttpUrl('file:///tmp/foo'), isFalse);
      expect(isValidHttpUrl('/relative/path'), isFalse);
    });
  });

  group('normalizeHttpUrlOrNull', () {
    test('trims and returns url when valid', () {
      expect(
        normalizeHttpUrlOrNull('  https://example.com/video '),
        'https://example.com/video',
      );
    });

    test('returns null for blank or invalid values', () {
      expect(normalizeHttpUrlOrNull(''), isNull);
      expect(normalizeHttpUrlOrNull('   '), isNull);
      expect(normalizeHttpUrlOrNull('ftp://example.com'), isNull);
    });
  });
}
