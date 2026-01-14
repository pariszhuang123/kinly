import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/harmony/data/supabase/supabase_mood_repository.dart';

void main() {
  test('getPersonalStatus parses status row', () async {
    final repo = SupabaseMoodRepository(
      client: SupabaseClient('https://example.supabase.co', 'anon'),
      rpc: (fn, {params}) async {
        expect(fn, 'personal_gratitude_wall_status_v1');
        return [
          {'has_unread': true, 'last_read_at': '2025-02-01T00:00:00Z'},
        ];
      },
    );

    final status = await repo.getPersonalStatus();
    expect(status.hasUnread, isTrue);
    expect(status.lastReadAt, isNotNull);
  });

  test('listPersonalWall parses items and cursor', () async {
    final repo = SupabaseMoodRepository(
      client: SupabaseClient('https://example.supabase.co', 'anon'),
      rpc: (fn, {params}) async {
        expect(fn, 'personal_gratitude_inbox_list_v1');
        return [
          {
            'id': 'i1',
            'created_at': '2025-02-01T00:00:00Z',
            'home_id': 'h1',
            'mood': 'sunny',
            'message': 'Thanks!',
            'source_kind': 'home_post',
            'source_post_id': 'p1',
            'source_entry_id': 'e1',
            'author_user_id': 'u1',
            'author_username': 'Alice',
            'author_avatar_path': 'avatars/a.png',
          },
        ];
      },
    );

    final page = await repo.listPersonalWall(limit: 10);
    expect(page.items.length, 1);
    expect(page.cursorId, 'i1');
    expect(page.items.first.authorUsername, 'Alice');
  });

  test('getPersonalStats parses counts', () async {
    final repo = SupabaseMoodRepository(
      client: SupabaseClient('https://example.supabase.co', 'anon'),
      rpc: (fn, {params}) async {
        expect(fn, 'personal_gratitude_showcase_stats_v1');
        return {
          'total_received': 3,
          'unique_individuals': 2,
          'unique_homes': 1,
        };
      },
    );

    final stats = await repo.getPersonalStats();
    expect(stats.totalReceived, 3);
    expect(stats.uniqueIndividuals, 2);
    expect(stats.uniqueHomes, 1);
  });
}
