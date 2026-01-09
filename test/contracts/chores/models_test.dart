import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/chores/models.dart';

void main() {
  group('Chore.fromJson', () {
    test('parses complete chore', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'assignee_user_id': 'user-111',
        'name': 'Clean kitchen',
        'start_date': '2024-01-15',
        'recurrence_every': 1,
        'recurrence_unit': 'week',
        'recurrence_cursor': '2024-01-22',
        'next_occurrence': '2024-01-29',
        'expectation_photo_path': 'photos/kitchen.jpg',
        'how_to_video_url': 'https://example.com/video',
        'notes': 'Use the blue sponge',
        'state': 'active',
        'completed_at': '2024-01-15T10:30:00Z',
        'created_at': '2024-01-01T10:30:00Z',
        'updated_at': '2024-01-02T10:30:00Z',
      };
      final result = Chore.fromJson(json);

      expect(result.id, 'chore-123');
      expect(result.homeId, 'home-456');
      expect(result.createdByUserId, 'user-789');
      expect(result.assigneeUserId, 'user-111');
      expect(result.name, 'Clean kitchen');
      expect(result.startDate.year, 2024);
      expect(result.startDate.month, 1);
      expect(result.startDate.day, 15);
      expect(result.recurrenceEvery, 1);
      expect(result.recurrenceUnit, ChoreRecurrenceUnit.week);
      expect(result.expectationPhotoPath, 'photos/kitchen.jpg');
      expect(result.howToVideoUrl, 'https://example.com/video');
      expect(result.notes, 'Use the blue sponge');
      expect(result.state, ChoreState.active);
      expect(result.completedAt, isNotNull);
    });

    test('handles null optional fields', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'assignee_user_id': null,
        'name': 'Clean kitchen',
        'start_date': '2024-01-15',
        'recurrence_every': null,
        'recurrence_unit': null,
        'state': 'draft',
        'created_at': '2024-01-01T10:30:00Z',
        'updated_at': '2024-01-02T10:30:00Z',
      };
      final result = Chore.fromJson(json);

      expect(result.assigneeUserId, isNull);
      expect(result.recurrenceEvery, isNull);
      expect(result.recurrenceUnit, isNull);
      expect(result.expectationPhotoPath, isNull);
      expect(result.howToVideoUrl, isNull);
      expect(result.notes, isNull);
      expect(result.completedAt, isNull);
      expect(result.state, ChoreState.draft);
    });

    test('handles camelCase recurrence keys', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'name': 'Vacuum',
        'start_date': '2024-01-15',
        'recurrenceEvery': 2,
        'recurrenceUnit': 'month',
        'state': 'active',
        'created_at': '2024-01-01T10:30:00Z',
        'updated_at': '2024-01-02T10:30:00Z',
      };
      final result = Chore.fromJson(json);

      expect(result.recurrenceEvery, 2);
      expect(result.recurrenceUnit, ChoreRecurrenceUnit.month);
    });

    test('coerces string recurrence_every to int', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'name': 'Vacuum',
        'start_date': '2024-01-15',
        'recurrence_every': '3',
        'recurrence_unit': 'day',
        'state': 'active',
        'created_at': '2024-01-01T10:30:00Z',
        'updated_at': '2024-01-02T10:30:00Z',
      };
      final result = Chore.fromJson(json);

      expect(result.recurrenceEvery, 3);
    });
  });

  group('ChoreListEntry.fromJson', () {
    test('parses complete entry', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'name': 'Laundry',
        'start_date': '2024-01-15',
        'assignee_user_id': 'user-111',
        'assignee_full_name': 'Alice',
        'assignee_avatar_storage_path': 'avatars/alice.png',
      };
      final result = ChoreListEntry.fromJson(json);

      expect(result.id, 'chore-123');
      expect(result.homeId, 'home-456');
      expect(result.name, 'Laundry');
      expect(result.assigneeUserId, 'user-111');
      expect(result.assigneeFullName, 'Alice');
      expect(result.assigneeAvatarStoragePath, 'avatars/alice.png');
    });

    test('handles unassigned chore', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'name': 'Laundry',
        'start_date': '2024-01-15',
      };
      final result = ChoreListEntry.fromJson(json);

      expect(result.assigneeUserId, isNull);
      expect(result.assigneeFullName, isNull);
      expect(result.assigneeAvatarStoragePath, isNull);
    });
  });

  group('TodayFlowEntry.fromJson', () {
    test('parses complete entry', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'name': 'Dishes',
        'start_date': '2024-01-15',
        'state': 'active',
      };
      final result = TodayFlowEntry.fromJson(json);

      expect(result.id, 'chore-123');
      expect(result.homeId, 'home-456');
      expect(result.name, 'Dishes');
      expect(result.state, ChoreState.active);
    });

    test('handles null state defaults to draft', () {
      final json = {
        'id': 'chore-123',
        'home_id': 'home-456',
        'name': 'Dishes',
        'start_date': '2024-01-15',
        'state': null,
      };
      final result = TodayFlowEntry.fromJson(json);

      expect(result.state, ChoreState.draft);
    });
  });

  group('ChoreAssigneeSummary.fromJson', () {
    test('parses with user_id key', () {
      final json = {
        'user_id': 'user-123',
        'full_name': 'Alice',
        'avatar_storage_path': 'avatars/alice.png',
        'is_owner': true,
      };
      final result = ChoreAssigneeSummary.fromJson(json);

      expect(result.userId, 'user-123');
      expect(result.fullName, 'Alice');
      expect(result.avatarStoragePath, 'avatars/alice.png');
      expect(result.isOwner, true);
    });

    test('parses with id key fallback', () {
      final json = {
        'id': 'user-456',
        'full_name': 'Bob',
      };
      final result = ChoreAssigneeSummary.fromJson(json);

      expect(result.userId, 'user-456');
    });

    test('defaults isOwner to false', () {
      final json = {
        'user_id': 'user-123',
      };
      final result = ChoreAssigneeSummary.fromJson(json);

      expect(result.isOwner, false);
    });
  });

  group('ChoreDetails.fromJson', () {
    test('parses chore with assignees', () {
      final json = {
        'chore': {
          'id': 'chore-123',
          'home_id': 'home-456',
          'created_by_user_id': 'user-789',
          'name': 'Clean',
          'start_date': '2024-01-15',
          'state': 'active',
          'created_at': '2024-01-01T10:30:00Z',
          'updated_at': '2024-01-02T10:30:00Z',
        },
        'assignees': [
          {'user_id': 'user-111', 'full_name': 'Alice'},
          {'user_id': 'user-222', 'full_name': 'Bob'},
        ],
      };
      final result = ChoreDetails.fromJson(json);

      expect(result.chore.id, 'chore-123');
      expect(result.assignees.length, 2);
      expect(result.assignees[0].fullName, 'Alice');
      expect(result.assignees[1].fullName, 'Bob');
    });

    test('handles empty assignees', () {
      final json = {
        'chore': {
          'id': 'chore-123',
          'home_id': 'home-456',
          'created_by_user_id': 'user-789',
          'name': 'Clean',
          'start_date': '2024-01-15',
          'state': 'draft',
          'created_at': '2024-01-01T10:30:00Z',
          'updated_at': '2024-01-02T10:30:00Z',
        },
        'assignees': null,
      };
      final result = ChoreDetails.fromJson(json);

      expect(result.assignees, isEmpty);
    });
  });

  group('ChoreCompletionResult.fromJson', () {
    test('parses non-recurring completed result', () {
      final json = {
        'status': 'non_recurring_completed',
        'chore_id': 'chore-123',
        'home_id': 'home-456',
        'state': 'active',
        'recurrence_every': 1,
        'recurrence_unit': 'week',
        'previous_next_occurrence': '2024-01-15',
        'new_next_occurrence': '2024-01-22',
        'steps_advanced': 1,
      };
      final result = ChoreCompletionResult.fromJson(json);

      expect(result.status, ChoreCompletionStatus.nonRecurringCompleted);
      expect(result.choreId, 'chore-123');
      expect(result.homeId, 'home-456');
      expect(result.state, ChoreState.active);
      expect(result.recurrenceEvery, 1);
      expect(result.recurrenceUnit, ChoreRecurrenceUnit.week);
      expect(result.stepsAdvanced, 1);
    });

    test('parses already_completed_for_cycle status', () {
      final json = {
        'status': 'already_completed_for_cycle',
        'chore_id': 'chore-123',
        'home_id': 'home-456',
      };
      final result = ChoreCompletionResult.fromJson(json);

      expect(result.status, ChoreCompletionStatus.alreadyCompletedForCycle);
    });

    test('parses recurring completed status', () {
      final json = {
        'status': 'recurring completed',
        'chore_id': 'chore-123',
        'home_id': 'home-456',
      };
      final result = ChoreCompletionResult.fromJson(json);

      expect(result.status, ChoreCompletionStatus.recurringCompleted);
    });

    test('handles null state', () {
      final json = {
        'status': 'non_recurring_completed',
        'chore_id': 'chore-123',
        'home_id': 'home-456',
        'state': null,
      };
      final result = ChoreCompletionResult.fromJson(json);

      expect(result.state, isNull);
    });
  });
}
