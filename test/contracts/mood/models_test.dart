import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';

void main() {
  group('MoodStatus.fromJson', () {
    test('parses submitted this week true', () {
      final json = {'value': true};
      final result = MoodStatus.fromJson(json);

      expect(result.isSubmittedThisWeek, true);
    });

    test('parses submitted this week false', () {
      final json = {'value': false};
      final result = MoodStatus.fromJson(json);

      expect(result.isSubmittedThisWeek, false);
    });

    test('handles first value in map', () {
      final json = {'is_submitted': true};
      final result = MoodStatus.fromJson(json);

      expect(result.isSubmittedThisWeek, true);
    });

    test('handles empty map defaults to false', () {
      final json = <String, dynamic>{};
      final result = MoodStatus.fromJson(json);

      expect(result.isSubmittedThisWeek, false);
    });
  });

  group('MoodSubmitResult.fromJson', () {
    test('parses with public post and mentions', () {
      final json = {
        'entry_id': 'entry-123',
        'public_post_id': 'post-456',
        'mention_count': 2,
      };
      final result = MoodSubmitResult.fromJson(json);

      expect(result.entryId, 'entry-123');
      expect(result.publicPostId, 'post-456');
      expect(result.mentionCount, 2);
    });

    test('parses without public post', () {
      final json = {'entry_id': 'entry-123', 'gratitude_post_id': null};
      final result = MoodSubmitResult.fromJson(json);

      expect(result.entryId, 'entry-123');
      expect(result.publicPostId, isNull);
      expect(result.mentionCount, 0);
    });
  });

  group('GratitudeWallPost.fromJson', () {
    test('parses complete post', () {
      final json = {
        'post_id': 'post-123',
        'author_user_id': 'user-456',
        'author_username': 'alice',
        'author_avatar_url': 'https://example.com/avatar.png',
        'mood': 'sunny',
        'message': 'Feeling grateful!',
        'created_at': '2024-01-15T10:30:00Z',
      };
      final result = GratitudeWallPost.fromJson(json);

      expect(result.id, 'post-123');
      expect(result.authorUserId, 'user-456');
      expect(result.authorUsername, 'alice');
      expect(result.authorAvatarUrl, 'https://example.com/avatar.png');
      expect(result.mood, MoodScale.sunny);
      expect(result.message, 'Feeling grateful!');
      expect(result.createdAt.year, 2024);
    });

    test('parses post without optional fields', () {
      final json = {
        'post_id': 'post-123',
        'author_user_id': 'user-456',
        'mood': 'cloudy',
        'created_at': '2024-01-15T10:30:00Z',
      };
      final result = GratitudeWallPost.fromJson(json);

      expect(result.authorUsername, isNull);
      expect(result.authorAvatarUrl, isNull);
      expect(result.message, isNull);
      expect(result.mood, MoodScale.cloudy);
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
          'post_id': 'post-123',
          'author_user_id': 'user-456',
          'mood': entry.key,
          'created_at': '2024-01-15T10:30:00Z',
        };
        final result = GratitudeWallPost.fromJson(json);

        expect(result.mood, entry.value);
      }
    });
  });

  group('GratitudeWallStatus.fromJson', () {
    test('parses with unread posts', () {
      final json = {'has_unread': true, 'last_read_at': '2024-01-15T10:30:00Z'};
      final result = GratitudeWallStatus.fromJson(json);

      expect(result.hasUnread, true);
      expect(result.lastReadAt, isNotNull);
    });

    test('parses with no unread posts', () {
      final json = {
        'has_unread': false,
        'last_read_at': '2024-01-20T10:30:00Z',
      };
      final result = GratitudeWallStatus.fromJson(json);

      expect(result.hasUnread, false);
    });

    test('handles null has_unread defaults to true', () {
      final json = {'last_read_at': null};
      final result = GratitudeWallStatus.fromJson(json);

      expect(result.hasUnread, true);
      expect(result.lastReadAt, isNull);
    });
  });

  group('GratitudeWallStats.fromJson', () {
    test('parses complete stats', () {
      final json = {
        'total_posts': 25,
        'unread_count': 5,
        'last_read_at': '2024-01-15T10:30:00Z',
      };
      final result = GratitudeWallStats.fromJson(json);

      expect(result.totalPosts, 25);
      expect(result.unreadCount, 5);
      expect(result.lastReadAt, isNotNull);
    });

    test('handles missing counts defaults to 0', () {
      final json = <String, dynamic>{};
      final result = GratitudeWallStats.fromJson(json);

      expect(result.totalPosts, 0);
      expect(result.unreadCount, 0);
      expect(result.lastReadAt, isNull);
    });

    test('handles numeric types', () {
      final json = {'total_posts': 10.0, 'unread_count': 3.0};
      final result = GratitudeWallStats.fromJson(json);

      expect(result.totalPosts, 10);
      expect(result.unreadCount, 3);
    });
  });
}
