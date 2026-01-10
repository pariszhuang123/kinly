import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/features/flow/domain/flow_chore_form.dart';

void main() {
  group('FlowChoreForm', () {
    group('initial', () {
      test('normalizes initial startDate to date-only', () {
        final start = DateTime(2025, 1, 31, 23, 45, 12);

        final form = FlowChoreForm.initial(startDate: start);

        expect(form.startDate, DateTime(2025, 1, 31));
      });

      test('uses current date when startDate not provided', () {
        final before = DateTime.now();
        final form = FlowChoreForm.initial();
        final after = DateTime.now();

        expect(form.startDate.year, before.year);
        expect(form.startDate.month, before.month);
        expect(form.startDate.day, greaterThanOrEqualTo(before.day));
        expect(form.startDate.day, lessThanOrEqualTo(after.day));
      });

      test('initial form has empty title', () {
        final form = FlowChoreForm.initial();
        expect(form.title, '');
      });

      test('initial form has null assignee', () {
        final form = FlowChoreForm.initial();
        expect(form.assigneeUserId, isNull);
      });

      test('initial form has no recurrence', () {
        final form = FlowChoreForm.initial();
        expect(form.recurrenceEvery, isNull);
        expect(form.recurrenceUnit, isNull);
        expect(form.isRecurring, isFalse);
      });

      test('initial form has empty notes', () {
        final form = FlowChoreForm.initial();
        expect(form.notes, '');
      });

      test('initial form has empty howToVideoUrl', () {
        final form = FlowChoreForm.initial();
        expect(form.howToVideoUrl, '');
      });

      test('initial form has empty expectationPhotoPath', () {
        final form = FlowChoreForm.initial();
        expect(form.expectationPhotoPath, '');
      });
    });

    group('copyWith', () {
      test('normalizes copyWith startDate to date-only', () {
        final form = FlowChoreForm.initial(
          startDate: DateTime(2025, 1, 30, 8, 15, 0),
        );
        final updated = form.copyWith(
          startDate: DateTime(2026, 2, 1, 15, 30, 0),
        );

        expect(updated.startDate, DateTime(2026, 2, 1));
      });

      test('updates title', () {
        final form = FlowChoreForm.initial();
        final updated = form.copyWith(title: 'Clean kitchen');

        expect(updated.title, 'Clean kitchen');
      });

      test('updates assignee to new value', () {
        final form = FlowChoreForm.initial();
        final updated = form.copyWith(assigneeUserId: 'user-123');

        expect(updated.assigneeUserId, 'user-123');
      });

      test('can set assignee to null explicitly', () {
        final form = FlowChoreForm.initial().copyWith(
          assigneeUserId: 'user-123',
        );
        final updated = form.copyWith(assigneeUserId: null);

        expect(updated.assigneeUserId, isNull);
      });

      test('clearRecurrence clears both recurrence fields', () {
        final form = FlowChoreForm.initial().copyWith(
          recurrenceEvery: 2,
          recurrenceUnit: ChoreRecurrenceUnit.week,
        );

        final cleared = form.copyWith(clearRecurrence: true);

        expect(cleared.recurrenceEvery, isNull);
        expect(cleared.recurrenceUnit, isNull);
      });

      test('preserves other fields when updating one', () {
        final form = FlowChoreForm.initial().copyWith(
          title: 'Vacuum',
          notes: 'Do twice weekly',
          howToVideoUrl: 'https://example.com/video',
        );

        final updated = form.copyWith(title: 'Mop');

        expect(updated.title, 'Mop');
        expect(updated.notes, 'Do twice weekly');
        expect(updated.howToVideoUrl, 'https://example.com/video');
      });
    });

    group('fromChore', () {
      test('populates all fields from Chore', () {
        final chore = Chore(
          id: 'chore-1',
          homeId: 'home-1',
          createdByUserId: 'creator-1',
          name: 'Do laundry',
          assigneeUserId: 'user-1',
          startDate: DateTime(2025, 6, 15, 10, 30),
          recurrenceEvery: 7,
          recurrenceUnit: ChoreRecurrenceUnit.day,
          recurrenceCursor: null,
          nextOccurrence: null,
          notes: 'Use cold water',
          howToVideoUrl: 'https://example.com/laundry',
          expectationPhotoPath: '/photos/laundry.jpg',
          state: ChoreState.active,
          completedAt: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final form = FlowChoreForm.fromChore(chore);

        expect(form.title, 'Do laundry');
        expect(form.assigneeUserId, 'user-1');
        expect(form.startDate, DateTime(2025, 6, 15));
        expect(form.recurrenceEvery, 7);
        expect(form.recurrenceUnit, ChoreRecurrenceUnit.day);
        expect(form.notes, 'Use cold water');
        expect(form.howToVideoUrl, 'https://example.com/laundry');
        expect(form.expectationPhotoPath, '/photos/laundry.jpg');
      });

      test('handles null optional fields', () {
        final chore = Chore(
          id: 'chore-1',
          homeId: 'home-1',
          createdByUserId: 'creator-1',
          name: 'Simple chore',
          assigneeUserId: null,
          startDate: DateTime(2025, 6, 15),
          recurrenceEvery: null,
          recurrenceUnit: null,
          recurrenceCursor: null,
          nextOccurrence: null,
          notes: null,
          howToVideoUrl: null,
          expectationPhotoPath: null,
          state: ChoreState.active,
          completedAt: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final form = FlowChoreForm.fromChore(chore);

        expect(form.assigneeUserId, isNull);
        expect(form.recurrenceEvery, isNull);
        expect(form.recurrenceUnit, isNull);
        expect(form.notes, '');
        expect(form.howToVideoUrl, '');
        expect(form.expectationPhotoPath, '');
      });
    });

    group('isTitleValid', () {
      test('returns false for empty title', () {
        final form = FlowChoreForm.initial();
        expect(form.isTitleValid, isFalse);
      });

      test('returns false for whitespace-only title', () {
        final form = FlowChoreForm.initial().copyWith(title: '   ');
        expect(form.isTitleValid, isFalse);
      });

      test('returns true for non-empty trimmed title', () {
        final form = FlowChoreForm.initial().copyWith(title: 'Clean dishes');
        expect(form.isTitleValid, isTrue);
      });
    });

    group('isHowToUrlValid', () {
      test('returns true for empty url', () {
        final form = FlowChoreForm.initial();
        expect(form.isHowToUrlValid, isTrue);
      });

      test('returns true for valid http url', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'http://example.com/video',
        );
        expect(form.isHowToUrlValid, isTrue);
      });

      test('returns true for valid https url', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'https://example.com/video',
        );
        expect(form.isHowToUrlValid, isTrue);
      });

      test('returns false for invalid url', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'not a url',
        );
        expect(form.isHowToUrlValid, isFalse);
      });
    });

    group('normalizedHowToUrl', () {
      test('returns null for empty url', () {
        final form = FlowChoreForm.initial();
        expect(form.normalizedHowToUrl, isNull);
      });

      test('returns url as-is for valid input with scheme', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'https://example.com/video',
        );
        expect(form.normalizedHowToUrl, 'https://example.com/video');
      });

      test('returns null for url without scheme', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'example.com/video',
        );
        expect(form.normalizedHowToUrl, isNull);
      });

      test('returns null for invalid url', () {
        final form = FlowChoreForm.initial().copyWith(
          howToVideoUrl: 'not valid',
        );
        expect(form.normalizedHowToUrl, isNull);
      });
    });

    group('isRecurring', () {
      test('returns false when recurrenceEvery is null', () {
        final form = FlowChoreForm.initial().copyWith(
          recurrenceUnit: ChoreRecurrenceUnit.week,
        );
        expect(form.isRecurring, isFalse);
      });

      test('returns false when recurrenceUnit is null', () {
        final form = FlowChoreForm.initial().copyWith(recurrenceEvery: 1);
        expect(form.isRecurring, isFalse);
      });

      test('returns true when both recurrence fields are set', () {
        final form = FlowChoreForm.initial().copyWith(
          recurrenceEvery: 2,
          recurrenceUnit: ChoreRecurrenceUnit.day,
        );
        expect(form.isRecurring, isTrue);
      });
    });

    group('isRecurrenceValid', () {
      test('returns true when not recurring', () {
        final form = FlowChoreForm.initial();
        expect(form.isRecurrenceValid, isTrue);
      });

      test('returns true for valid recurrence >= 1', () {
        final form = FlowChoreForm.initial().copyWith(
          recurrenceEvery: 1,
          recurrenceUnit: ChoreRecurrenceUnit.day,
        );
        expect(form.isRecurrenceValid, isTrue);
      });

      test('returns false for recurrenceEvery < 1 when recurring', () {
        final form = FlowChoreForm.initial().copyWith(
          recurrenceEvery: 0,
          recurrenceUnit: ChoreRecurrenceUnit.day,
        );
        expect(form.isRecurrenceValid, isFalse);
      });
    });

    group('isStartDateInRange', () {
      test('returns true for today', () {
        final now = DateTime(2025, 6, 15);
        final form = FlowChoreForm.initial(startDate: now);

        expect(form.isStartDateInRange(now), isTrue);
      });

      test('returns true for date within one year', () {
        final now = DateTime(2025, 6, 15);
        final form = FlowChoreForm.initial(startDate: DateTime(2026, 6, 15));

        expect(form.isStartDateInRange(now), isTrue);
      });

      test('returns false for date more than one year ahead', () {
        final now = DateTime(2025, 6, 15);
        final form = FlowChoreForm.initial(startDate: DateTime(2026, 6, 16));

        expect(form.isStartDateInRange(now), isFalse);
      });
    });

    group('equality', () {
      test('equal forms are equal', () {
        final startDate = DateTime(2025, 6, 15);
        final form1 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Clean');
        final form2 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Clean');

        expect(form1, equals(form2));
        expect(form1.hashCode, equals(form2.hashCode));
      });

      test('different forms are not equal', () {
        final startDate = DateTime(2025, 6, 15);
        final form1 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Clean');
        final form2 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Mop');

        expect(form1, isNot(equals(form2)));
      });

      test('isEqualTo returns true for equivalent forms', () {
        final startDate = DateTime(2025, 6, 15);
        final form1 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Clean');
        final form2 = FlowChoreForm.initial(
          startDate: startDate,
        ).copyWith(title: 'Clean');

        expect(form1.isEqualTo(form2), isTrue);
      });
    });
  });
}
