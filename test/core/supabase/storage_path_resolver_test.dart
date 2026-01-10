import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/core/supabase/storage_path_resolver.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockStorageClient extends Mock implements SupabaseStorageClient {}

class _MockStorageFileApi extends Mock implements StorageFileApi {}

void main() {
  late _MockSupabaseClient supabase;
  late _MockStorageClient storage;
  late _MockStorageFileApi fileApi;

  setUp(() {
    supabase = _MockSupabaseClient();
    storage = _MockStorageClient();
    fileApi = _MockStorageFileApi();

    when(() => supabase.storage).thenReturn(storage);
    when(() => storage.from(any())).thenReturn(fileApi);
    when(() => fileApi.getPublicUrl(any())).thenAnswer(
      (invocation) => 'public://${invocation.positionalArguments.first}',
    );
  });

  test('returns null for null or empty', () {
    expect(storagePathToPublicUrl(supabase, null), isNull);
    expect(storagePathToPublicUrl(supabase, '   '), isNull);
  });

  test('returns unchanged for full URLs', () {
    expect(
      storagePathToPublicUrl(supabase, 'https://example.com/avatar.png'),
      'https://example.com/avatar.png',
    );
  });

  test('resolves bucket/object when bucket provided', () {
    final url = storagePathToPublicUrl(supabase, 'avatars/user.png');
    expect(url, 'public://user.png');
    verify(() => storage.from('avatars')).called(1);
    verify(() => fileApi.getPublicUrl('user.png')).called(1);
  });

  test('defaults to households bucket when none provided', () {
    final url = storagePathToPublicUrl(supabase, 'photos/abc.png');
    expect(url, 'public://photos/abc.png');
    verify(() => storage.from('households')).called(1);
    verify(() => fileApi.getPublicUrl('photos/abc.png')).called(1);
  });

  test('returns null for empty object path after parsing', () {
    expect(storagePathToPublicUrl(supabase, 'households/'), isNull);
  });
}
