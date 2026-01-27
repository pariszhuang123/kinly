import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pending_join_intent.dart';

/// Persists pending invite join intents across cold/warm starts.
class PendingJoinIntentStorage {
  PendingJoinIntentStorage({
    FlutterSecureStorage? storage,
    String key = _defaultKey,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _key = key;

  static const _defaultKey = 'pending_join_intent';

  final FlutterSecureStorage _storage;
  final String _key;

  Future<PendingJoinIntent?> load() async {
    final encoded = await _storage.read(key: _key);
    if (encoded == null || encoded.isEmpty) return null;
    try {
      return PendingJoinIntent.fromEncoded(encoded);
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(PendingJoinIntent intent) async {
    await _storage.write(key: _key, value: intent.toEncoded());
  }

  Future<void> clear() => _storage.delete(key: _key);
}
