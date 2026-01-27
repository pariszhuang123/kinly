import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/links/invite_code_parser.dart';
import 'package:kinly/core/links/pending_join_intent.dart';

void main() {
  group('InviteCodeParser', () {
    const parser = InviteCodeParser();

    PendingJoinIntent parse(Uri uri) {
      final intent = parser.parse(uri);
      expect(intent, isNotNull);
      return intent!;
    }

    test('parses path-based invite and normalizes to uppercase', () {
    final intent = parse(
      Uri.parse('https://go.makinglifeeasie.com/kinly/join/ab23cd'),
    );

    expect(intent.inviteCode, 'AB23CD');
    expect(intent.source, isNull);
  });

    test('rejects invalid length', () {
      final result = parser.parse(
        Uri.parse('https://go.makinglifeeasie.com/kinly/join/ABCDE'),
      );

      expect(result, isNull);
    });

    test('uses query param aliases', () {
      final intent = parse(Uri.parse('kinly://join?inviteCode=abc234'));

      expect(intent.inviteCode, 'ABC234');
    });

    test('ignores forbidden characters', () {
      final result = parser.parse(Uri.parse('kinly://join?code=AB1O2I'));

      expect(result, isNull);
    });
  });
}
