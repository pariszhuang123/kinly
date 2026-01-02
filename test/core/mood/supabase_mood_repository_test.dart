import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/features/harmony/data/supabase/supabase_mood_repository.dart';

void main() {
  const homeId = 'home';
  const comment = 'note';
  const expected = MoodSubmitResult(entryId: 'e1', gratitudePostId: 'g1');

  test('submit accepts list response from mood_submit', () async {
    final repository = SupabaseMoodRepository(
      client: SupabaseClient('https://example.supabase.co', 'anon-key'),
      rpc: (fn, {params}) async {
        expect(fn, 'mood_submit');
        expect(params, {
          'p_home_id': homeId,
          'p_mood': MoodScale.sunny.wireValue,
          'p_comment': comment,
          'p_add_to_wall': true,
        });
        return [
          {
            'entry_id': expected.entryId,
            'gratitude_post_id': expected.gratitudePostId,
          },
        ];
      },
    );

    final result = await repository.submit(
      homeId: homeId,
      mood: MoodScale.sunny,
      comment: comment,
      addToWall: true,
    );

    expect(result, expected);
  });
}
