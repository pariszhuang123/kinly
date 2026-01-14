import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/logging/enums/log_level.dart';

void main() {
  group('LogLevel', () {
    group('values', () {
      test('has 4 values', () {
        expect(LogLevel.values.length, 4);
      });

      test('debug is a value', () {
        expect(LogLevel.values, contains(LogLevel.debug));
      });

      test('info is a value', () {
        expect(LogLevel.values, contains(LogLevel.info));
      });

      test('warning is a value', () {
        expect(LogLevel.values, contains(LogLevel.warning));
      });

      test('error is a value', () {
        expect(LogLevel.values, contains(LogLevel.error));
      });
    });

    group('label extension', () {
      test('debug label is DEBUG', () {
        expect(LogLevel.debug.label, 'DEBUG');
      });

      test('info label is INFO', () {
        expect(LogLevel.info.label, 'INFO');
      });

      test('warning label is WARN', () {
        expect(LogLevel.warning.label, 'WARN');
      });

      test('error label is ERROR', () {
        expect(LogLevel.error.label, 'ERROR');
      });
    });
  });
}
