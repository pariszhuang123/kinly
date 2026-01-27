import 'pending_join_intent.dart';

class InviteCodeParser {
  const InviteCodeParser();

  static final _regex = RegExp(r'^[A-HJ-NP-Z2-9]{6}$', caseSensitive: false);

  /// Extracts and validates an invite code + source from the given URI.
  /// Returns `null` when no valid invite code is present.
  PendingJoinIntent? parse(Uri uri) {
    final code = _extractCode(uri);
    if (code == null) return null;
    final normalized = code.trim().toUpperCase();
    if (!_regex.hasMatch(normalized)) return null;

    final rawSource =
        uri.queryParameters['source'] ?? uri.queryParameters['utm_source'];
    final source =
        (rawSource?.trim().isNotEmpty ?? false) ? rawSource!.trim() : null;

    return PendingJoinIntent(
      inviteCode: normalized,
      receivedAt: DateTime.now().toUtc(),
      source: source,
    );
  }

  String? _extractCode(Uri uri) {
    // Query aliases
    final query = uri.queryParameters;
    final aliases = ['invite_code', 'inviteCode', 'invite_id', 'code'];
    for (final alias in aliases) {
      final value = query[alias];
      if (value != null && value.trim().isNotEmpty) return value;
    }

    // Path form: /kinly/join/:code or /join/:code
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      final joinIndex = segments.indexOf('join');
      if (joinIndex >= 0 && joinIndex < segments.length - 1) {
        return segments[joinIndex + 1];
      }
    }

    return null;
  }
}
