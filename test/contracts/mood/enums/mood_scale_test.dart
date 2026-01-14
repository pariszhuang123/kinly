import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';

void main() {
  group('MoodScale', () {
    group('wireValue', () {
      test('sunny has wireValue "sunny"', () {
        expect(MoodScale.sunny.wireValue, 'sunny');
      });

      test('partiallySunny has wireValue "partially_sunny"', () {
        expect(MoodScale.partiallySunny.wireValue, 'partially_sunny');
      });

      test('cloudy has wireValue "cloudy"', () {
        expect(MoodScale.cloudy.wireValue, 'cloudy');
      });

      test('rainy has wireValue "rainy"', () {
        expect(MoodScale.rainy.wireValue, 'rainy');
      });

      test('thunderstorm has wireValue "thunderstorm"', () {
        expect(MoodScale.thunderstorm.wireValue, 'thunderstorm');
      });
    });

    group('fromWire', () {
      test('parses "sunny" to MoodScale.sunny', () {
        expect(MoodScale.fromWire('sunny'), MoodScale.sunny);
      });

      test('parses "partially_sunny" to MoodScale.partiallySunny', () {
        expect(MoodScale.fromWire('partially_sunny'), MoodScale.partiallySunny);
      });

      test('parses "cloudy" to MoodScale.cloudy', () {
        expect(MoodScale.fromWire('cloudy'), MoodScale.cloudy);
      });

      test('parses "rainy" to MoodScale.rainy', () {
        expect(MoodScale.fromWire('rainy'), MoodScale.rainy);
      });

      test('parses "thunderstorm" to MoodScale.thunderstorm', () {
        expect(MoodScale.fromWire('thunderstorm'), MoodScale.thunderstorm);
      });

      test('throws ArgumentError for unknown value', () {
        expect(
          () => MoodScale.fromWire('unknown'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Unknown mood_scale: unknown',
            ),
          ),
        );
      });

      test('throws ArgumentError for empty string', () {
        expect(() => MoodScale.fromWire(''), throwsA(isA<ArgumentError>()));
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final mood in MoodScale.values) {
          final wireValue = mood.wireValue;
          final parsed = MoodScale.fromWire(wireValue);
          expect(parsed, mood);
        }
      });
    });
  });
}
