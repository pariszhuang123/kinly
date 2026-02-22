import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/features/house_norms/domain/house_norm_document_view.dart';

void main() {
  group('HouseNormDocument.fromJson', () {
    test('parses owner flags and public metadata', () {
      final document = HouseNormDocument.fromJson(
        homeId: 'home-1',
        json: const {
          'template_key': 'house_norms_v1',
          'status': 'out_of_date',
          'inputs': {
            'norms_rhythm_quiet': 1,
            'norms_shared_spaces': 2,
          },
          'draft_content': {
            'summary': {
              'title': 'House norms',
              'subtitle': 'Shared defaults',
              'framing': 'A shared starting point.',
            },
            'context': 'We share this home.',
            'sections': [
              {
                'section_key': 'norms_rhythm_quiet',
                'title': 'Rhythm',
                'text': 'We try to wind down at night.',
              },
            ],
          },
          'published_content': {
            'summary': {
              'title': 'Published house norms',
              'subtitle': 'Published defaults',
              'framing': 'Published framing.',
            },
            'context': 'Published context.',
            'sections': [
              {
                'section_key': 'norms_shared_spaces',
                'title': 'Shared spaces',
                'text': 'Published section text.',
              },
            ],
          },
          'is_published': true,
          'has_unpublished_changes': true,
          'home_public_id': 'home_public_1',
          'public_url': 'https://go.makinglifeeasie.com/norms/home_public_1',
          'show_publish_button': false,
          'show_republish_button': true,
          'show_public_url': true,
        },
      );

      expect(document.homeId, 'home-1');
      expect(document.status, 'out_of_date');
      expect(document.inputs['norms_rhythm_quiet'], 1);
      expect(document.homePublicId, 'home_public_1');
      expect(document.publicUrl, isNotNull);
      expect(document.showPublishButton, isFalse);
      expect(document.showRepublishButton, isTrue);
      expect(document.showPublicUrl, isTrue);
      expect(
        resolveHouseNormDisplayContent(document)?.sections.first.sectionKey,
        'norms_rhythm_quiet',
      );
    });

    test('parses section object map payloads keyed by section id', () {
      final document = HouseNormDocument.fromJson(
        homeId: 'home-1',
        json: const {
          'status': 'published',
          'published_content': {
            'summary': {
              'title_key': 'house_norms_title',
              'subtitle_key': 'house_norms_subtitle',
              'framing': 'We aim for calm and workable shared life.',
            },
            'context': {
              'line': 'This home is shared by family.',
            },
            'sections': {
              'norms_shared_spaces': {
                'title_key': 'house_norms_section_shared_spaces_title',
                'text': 'We reset shared spaces when it makes sense.',
              },
              'norms_repair_style': {
                'title_key': 'house_norms_section_repair_style_title',
                'text': 'We try to talk sooner rather than later.',
              },
            },
          },
        },
      );

      final content = resolveHouseNormDisplayContent(document);
      expect(content, isNotNull);
      expect(content!.sections, hasLength(2));
      expect(content.sections.first.sectionKey, 'norms_shared_spaces');
      expect(content.sections.first.title, isEmpty);
      expect(
        content.sections.first.titleKey,
        'house_norms_section_shared_spaces_title',
      );
      expect(
        content.sections.first.text,
        'We reset shared spaces when it makes sense.',
      );
    });

    test('parses member review metadata from payload', () {
      final document = HouseNormDocument.fromJson(
        homeId: 'home-1',
        json: const {
          'status': 'published',
          'member_viewed_at': '2026-01-02T03:04:05Z',
          'show_member_review_card': true,
          'published_content': {
            'summary': {'title': 'House norms', 'subtitle': '', 'framing': ''},
            'context': '',
            'sections': [],
          },
        },
      );

      expect(document.memberViewedAt, DateTime.parse('2026-01-02T03:04:05Z'));
      expect(document.showMemberReviewCard, isTrue);
    });

    test('display content falls back to published then draft', () {
      final publishedOnly = HouseNormDocument(
        homeId: 'home-1',
        templateKey: 'house_norms_v1',
        status: 'published',
        inputs: const {},
        draftContent: null,
        draftUpdatedAt: null,
        publishedContent: const HouseNormContent(
          summary: HouseNormSummary(
            title: 'Published',
            subtitle: 'Subtitle',
            framing: 'Framing',
          ),
          context: 'Context',
          sections: [
            HouseNormSection(
              sectionKey: 'norms_home_identity',
              title: 'Identity',
              text: 'Published text',
            ),
          ],
        ),
        publishedAt: null,
        publishedVersion: null,
        isPublished: true,
        hasUnpublishedChanges: false,
        lastEditedAt: null,
        lastEditedBy: null,
        homePublicId: null,
        publicUrl: null,
        showPublishButton: false,
        showRepublishButton: false,
        showPublicUrl: false,
        memberViewedAt: null,
        showMemberReviewCard: false,
      );

      expect(
        resolveHouseNormDisplayContent(publishedOnly)?.sections.first.sectionKey,
        'norms_home_identity',
      );
    });
  });
}
