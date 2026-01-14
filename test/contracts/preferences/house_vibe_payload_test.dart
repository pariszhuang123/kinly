import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/preferences/models.dart';

void main() {
  test(
    'maps presentation fields when provided in nested presentation object',
    () {
      final payload = HouseVibePayload.fromJson({
        'home_id': 'home-1',
        'mapping_version': 'v1',
        'label_id': 'structured_home',
        'coverage': {'answered': 2, 'total': 5},
        'presentation': {
          'title_key': 'vibe.structured.title',
          'summary_key': 'vibe.structured.summary',
          'image_key': 'structured_v1',
          'ui': {'cta': 'cta_key'},
        },
      });

      expect(payload.titleKey, 'vibe.structured.title');
      expect(payload.summaryKey, 'vibe.structured.summary');
      expect(payload.imageKey, 'structured_v1');
      expect(payload.ui, containsPair('cta', 'cta_key'));
    },
  );
}
