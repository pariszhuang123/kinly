import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/core/supabase/supabase_error_mapper.dart';

void main() {
  group('SupabaseErrorMapper profile deactivated', () {
    test('mapCreate maps PROFILE_DEACTIVATED', () {
      final error = PostgrestException(
        message: '{"code":"PROFILE_DEACTIVATED","message":"blocked"}',
      );

      final mapped = SupabaseErrorMapper.mapCreate(error);

      expect(mapped.code, CreateHomeErrorCode.profileDeactivated);
    });

    test('mapJoin maps PROFILE_DEACTIVATED', () {
      final error = PostgrestException(
        message: '{"code":"PROFILE_DEACTIVATED","message":"blocked"}',
      );

      final mapped = SupabaseErrorMapper.mapJoin(error);

      expect(mapped.code, JoinErrorCode.profileDeactivated);
    });
  });
}
