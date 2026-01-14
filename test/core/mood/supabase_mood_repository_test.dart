import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/features/harmony/data/supabase/supabase_mood_repository.dart';

void main() {
  const homeId = 'home';
  const comment = 'note';
  const expected = MoodSubmitResult(entryId: 'e1', publicPostId: 'g1', mentionCount: 1);

  test('submit accepts list response from mood_submit_v2', () async {
    final repository = SupabaseMoodRepository(
      client: SupabaseClient('https://example.supabase.co', 'anon-key'),
      rpc: (fn, {params}) async {
        expect(fn, 'mood_submit_v2');
        expect(params, {
          'p_home_id': homeId,
          'p_mood': MoodScale.sunny.wireValue,
          'p_comment': comment,
          'p_public_wall': true,
          'p_mentions': ['u1'],
        });
        return [
          {
            'entry_id': expected.entryId,
            'public_post_id': expected.publicPostId,
            'mention_count': expected.mentionCount,
          },
        ];
      },
    );

    final result = await repository.submit(
      homeId: homeId,
      mood: MoodScale.sunny,
      comment: comment,
      addToWall: true,
      mentions: const ['u1'],
    );

    expect(result, expected);
  });
}
