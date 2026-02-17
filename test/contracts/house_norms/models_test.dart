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
      );

      expect(
        resolveHouseNormDisplayContent(publishedOnly)?.sections.first.sectionKey,
        'norms_home_identity',
      );
    });
  });
}
