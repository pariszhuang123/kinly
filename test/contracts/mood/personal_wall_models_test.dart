import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/personal_wall_models.dart';

void main() {
  group('PersonalGratitudeStatus.fromJson', () {
    test('parses with unread items', () {
      final json = {
        'has_unread': true,
        'last_read_at': '2024-01-15T10:30:00Z',
      };
      final result = PersonalGratitudeStatus.fromJson(json);

      expect(result.hasUnread, true);
      expect(result.lastReadAt, isNotNull);
    });

    test('parses with no unread items', () {
      final json = {'has_unread': false, 'last_read_at': null};
      final result = PersonalGratitudeStatus.fromJson(json);

      expect(result.hasUnread, false);
      expect(result.lastReadAt, isNull);
    });

    test('defaults hasUnread to false when null', () {
      final json = <String, dynamic>{};
      final result = PersonalGratitudeStatus.fromJson(json);

      expect(result.hasUnread, false);
    });
  });

  group('PersonalGratitudeItem.fromJson', () {
    test('parses complete item', () {
      final json = {
        'id': 'item-123',
        'created_at': '2024-01-15T10:30:00Z',
        'home_id': 'home-456',
        'mood': 'sunny',
        'message': 'Thank you!',
        'source_kind': 'wall_post',
        'source_post_id': 'post-789',
        'source_entry_id': 'entry-012',
        'author_user_id': 'user-abc',
        'author_username': 'alice',
        'author_avatar_path': '/avatars/alice.png',
      };
      final result = PersonalGratitudeItem.fromJson(json);

      expect(result.id, 'item-123');
      expect(result.createdAt, isNotNull);
      expect(result.homeId, 'home-456');
      expect(result.mood, MoodScale.sunny);
      expect(result.message, 'Thank you!');
      expect(result.sourceKind, 'wall_post');
      expect(result.sourcePostId, 'post-789');
      expect(result.sourceEntryId, 'entry-012');
      expect(result.authorUserId, 'user-abc');
      expect(result.authorUsername, 'alice');
      expect(result.authorAvatarPath, '/avatars/alice.png');
    });

    test('parses item with nullable fields as null', () {
      final json = {
        'id': 'item-123',
        'created_at': '2024-01-15T10:30:00Z',
        'home_id': 'home-456',
        'mood': 'cloudy',
        'message': null,
        'source_post_id': null,
        'author_user_id': 'user-abc',
        'author_avatar_path': null,
      };
      final result = PersonalGratitudeItem.fromJson(json);

      expect(result.message, isNull);
      expect(result.sourcePostId, isNull);
      expect(result.authorAvatarPath, isNull);
    });

    test('defaults source_kind to mention_only', () {
      final json = {
        'id': 'item-123',
        'created_at': '2024-01-15T10:30:00Z',
        'home_id': 'home-456',
        'mood': 'sunny',
        'author_user_id': 'user-abc',
      };
      final result = PersonalGratitudeItem.fromJson(json);

      expect(result.sourceKind, 'mention_only');
    });

    test('defaults source_entry_id to empty string', () {
      final json = {
        'id': 'item-123',
        'created_at': '2024-01-15T10:30:00Z',
        'home_id': 'home-456',
        'mood': 'sunny',
        'author_user_id': 'user-abc',
      };
      final result = PersonalGratitudeItem.fromJson(json);

      expect(result.sourceEntryId, '');
    });

    test('defaults author_username to empty string', () {
      final json = {
        'id': 'item-123',
        'created_at': '2024-01-15T10:30:00Z',
        'home_id': 'home-456',
        'mood': 'sunny',
        'author_user_id': 'user-abc',
        'author_username': null,
      };
      final result = PersonalGratitudeItem.fromJson(json);

      expect(result.authorUsername, '');
    });

    test('parses different mood values', () {
      final moodValues = {
        'sunny': MoodScale.sunny,
        'partially_sunny': MoodScale.partiallySunny,
        'cloudy': MoodScale.cloudy,
        'rainy': MoodScale.rainy,
        'thunderstorm': MoodScale.thunderstorm,
      };

      for (final entry in moodValues.entries) {
        final json = {
          'id': 'item-123',
          'created_at': '2024-01-15T10:30:00Z',
          'home_id': 'home-456',
          'mood': entry.key,
          'author_user_id': 'user-abc',
        };
        final result = PersonalGratitudeItem.fromJson(json);

        expect(result.mood, entry.value);
      }
    });
  });

  group('PersonalGratitudeStats.fromJson', () {
    test('parses complete stats', () {
      final json = {
        'total_received': 25,
        'unique_individuals': 10,
        'unique_homes': 3,
      };
      final result = PersonalGratitudeStats.fromJson(json);

      expect(result.totalReceived, 25);
      expect(result.uniqueIndividuals, 10);
      expect(result.uniqueHomes, 3);
    });

    test('handles missing fields with zero defaults', () {
      final json = <String, dynamic>{};
      final result = PersonalGratitudeStats.fromJson(json);

      expect(result.totalReceived, 0);
      expect(result.uniqueIndividuals, 0);
      expect(result.uniqueHomes, 0);
    });

    test('handles numeric types (double to int)', () {
      final json = {
        'total_received': 15.0,
        'unique_individuals': 5.0,
        'unique_homes': 2.0,
      };
      final result = PersonalGratitudeStats.fromJson(json);

      expect(result.totalReceived, 15);
      expect(result.uniqueIndividuals, 5);
      expect(result.uniqueHomes, 2);
    });
  });

  group('PersonalGratitudePage', () {
    test('constructs with all fields', () {
      final now = DateTime.now();
      final page = PersonalGratitudePage(
        items: const [],
        cursorCreatedAt: now,
        cursorId: 'cursor-123',
      );

      expect(page.items, isEmpty);
      expect(page.cursorCreatedAt, now);
      expect(page.cursorId, 'cursor-123');
    });

    test('constructs with null cursor fields', () {
      const page = PersonalGratitudePage(
        items: [],
        cursorCreatedAt: null,
        cursorId: null,
      );

      expect(page.cursorCreatedAt, isNull);
      expect(page.cursorId, isNull);
    });
  });

  group('Equatable props', () {
    test('PersonalGratitudeStatus equality', () {
      const status1 = PersonalGratitudeStatus(hasUnread: true, lastReadAt: null);
      const status2 = PersonalGratitudeStatus(hasUnread: true, lastReadAt: null);

      expect(status1, equals(status2));
    });

    test('PersonalGratitudeStats equality', () {
      const stats1 = PersonalGratitudeStats(
        totalReceived: 10,
        uniqueIndividuals: 5,
        uniqueHomes: 2,
      );
      const stats2 = PersonalGratitudeStats(
        totalReceived: 10,
        uniqueIndividuals: 5,
        uniqueHomes: 2,
      );

      expect(stats1, equals(stats2));
    });
  });
}
