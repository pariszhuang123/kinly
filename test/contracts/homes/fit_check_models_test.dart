import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';

void main() {
  group('FitCheckOwnerReview.fromJson', () {
    test('sorts submissions newest first and keeps duplicate names separate', () {
      final review = FitCheckOwnerReview.fromJson({
        'draft_id': 'draft-1',
        'home_id': 'home-1',
        'owner_summary': {
          'labels': ['Quiet nights'],
        },
        'submissions': [
          {
            'submission_id': 'submission-older',
            'display_name': 'Alex',
            'review_label': 'Alex · Mar 10',
            'submitted_at': '2026-03-10T09:00:00Z',
            'preview': {
              'summary_label': 'Older',
            },
          },
          {
            'submission_id': 'submission-newer',
            'display_name': 'Alex',
            'review_label': 'Alex · Mar 21',
            'submitted_at': '2026-03-21T09:00:00Z',
            'preview': {
              'summary_label': 'Newer',
            },
          },
        ],
      });

      final submissions = fitCheckReviewSubmissions(review);
      expect(submissions, hasLength(2));
      expect(submissions.first.submissionId, 'submission-newer');
      expect(submissions.last.submissionId, 'submission-older');
      expect(
        submissions.map((entry) => entry.displayName),
        ['Alex', 'Alex'],
      );
    });

    test('groups current and historical share generations with current first', () {
      final review = FitCheckOwnerReview.fromJson({
        'draft_id': 'draft-1',
        'share_groups': [
          {
            'share_generation_id': 'older',
            'share_token_status': 'revoked',
            'created_at': '2026-03-10T09:00:00Z',
            'submissions': [
              {
                'submission_id': 'submission-older',
                'display_name': 'Jordan',
                'review_label': 'Jordan',
                'submitted_at': '2026-03-10T10:00:00Z',
                'preview': {'summary_label': 'Older'},
              },
            ],
          },
          {
            'share_generation_id': 'current',
            'share_token_status': 'active',
            'created_at': '2026-03-21T09:00:00Z',
            'submissions': [
              {
                'submission_id': 'submission-current',
                'display_name': 'Alex',
                'review_label': 'Alex',
                'submitted_at': '2026-03-21T10:00:00Z',
                'preview': {'summary_label': 'Current'},
              },
            ],
          },
        ],
      });

      expect(review.shareGenerations, hasLength(2));
      expect(review.shareGenerations.first.generationId, 'current');
      expect(fitCheckCurrentShareGeneration(review)?.generationId, 'current');
      expect(review.shareGenerations.last.generationId, 'older');
    });
  });

  group('FitCheckOwnerBriefing.fromJson', () {
    test('parses alignments from object and string forms', () {
      final briefing = FitCheckOwnerBriefing.fromJson({
        'submission_id': 'submission-1',
        'draft_id': 'draft-1',
        'candidate': {
          'display_name': 'Alex',
          'submitted_at': '2026-03-21T09:00:00Z',
          'answers': {
            'fit_cleanliness': 2,
          },
        },
        'briefing': {
          'alignments': [
            {'scenario_id': 'fit_cleanliness'},
            'fit_rhythm',
          ],
        },
      });

      expect(briefing.alignments, ['fit_cleanliness', 'fit_rhythm']);
    });

    test('parses optional alignment preview text', () {
      final briefing = FitCheckOwnerBriefing.fromJson({
        'submission_id': 'submission-1',
        'draft_id': 'draft-1',
        'candidate': {
          'display_name': 'Alex',
          'submitted_at': '2026-03-21T09:00:00Z',
          'answers': {
            'fit_cleanliness': 2,
          },
        },
        'briefing': {
          'alignment_preview_text': 'Mostly aligned on rhythms.',
        },
      });

      expect(briefing.alignmentPreviewText, 'Mostly aligned on rhythms.');
    });

    test('parses focus text and primary watchouts', () {
      final briefing = FitCheckOwnerBriefing.fromJson({
        'submission_id': 'submission-1',
        'draft_id': 'draft-1',
        'candidate': {
          'display_name': 'Alex',
          'submitted_at': '2026-03-21T09:00:00Z',
          'answers': {
            'fit_cleanliness': 2,
          },
        },
        'briefing': {
          'focus_text': 'Start with the top watchouts first.',
          'watchouts': [
            {
              'scenario_id': 'fit_cleanliness',
              'distance': 2,
              'direction': 'candidate_higher',
              'watchout_text': 'Cleanliness may create tension.',
              'is_primary_focus': true,
            },
          ],
        },
      });

      expect(briefing.focusText, 'Start with the top watchouts first.');
      expect(briefing.watchouts.single.isPrimaryFocus, isTrue);
    });
  });
}
