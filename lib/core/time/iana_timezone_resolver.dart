import 'package:flutter_timezone/flutter_timezone.dart';

import '../logging/logger.dart';

/// Public alias so resolver can be injected/tested without leaking a private type.
typedef TimezoneLoader = Future<String> Function();

/// Resolves the device timezone to an IANA identifier with a safe fallback.
class IanaTimezoneResolver {
  IanaTimezoneResolver({
    required Logger logger,
    TimezoneLoader? loader,
  })  : _logger = logger,
        _loadTimezone = loader ?? _defaultLoader;

  static Future<String> _defaultLoader() async {
    final info = await FlutterTimezone.getLocalTimezone();
    final identifier = info.identifier.trim();
    if (identifier.isNotEmpty) return identifier;
    // Fallback in case the plugin returns an unexpected payload.
    final extracted = _extractName(info);
    if (extracted != null && extracted.isNotEmpty) return extracted;
    throw StateError('Unsupported timezone result type: ${info.runtimeType}');
  }

  static String? _extractName(dynamic value) {
    String? tryRead(String? Function() reader) {
      try {
        final s = reader();
        if (s != null && s.isNotEmpty) return s;
      } catch (_) {
        // ignore and continue
      }
      return null;
    }

    final direct = tryRead(() => value.toString());
    if (direct != null && _ianaRegex.hasMatch(direct)) return direct;

    final candidates = <String?>[
      tryRead(() => value.identifier?.toString()),
      tryRead(() => value.name?.toString()),
      tryRead(() => value.timeZone?.toString()),
      tryRead(() => value.timezone?.toString()),
      tryRead(() => value.timeZoneId?.toString()),
      tryRead(() => value.timezoneId?.toString()),
    ];

    for (final c in candidates) {
      if (c == null || c.isEmpty) continue;
      if (_ianaRegex.hasMatch(c)) return c;
      final match = RegExp(r'name:\s*([A-Za-z_]+(?:/[A-Za-z_]+)+|UTC)')
          .firstMatch(c);
      if (match != null) return match.group(1);
    }

    // Last-resort parse from toString() if it contains name: ...
    if (direct != null) {
      final match =
          RegExp(r'name:\s*([A-Za-z_]+(?:/[A-Za-z_]+)+|UTC)').firstMatch(direct);
      if (match != null) return match.group(1);
    }
    return null;
  }

  /// Optional override for local/dev debugging to force a specific timezone.
  /// Do not set in production builds.
  static String? debugOverride;

  static const _logTag = 'Timezone';
  static final _ianaRegex =
      RegExp(r'^[A-Za-z_]+(?:/[A-Za-z_]+)+$|^UTC$', multiLine: false);

  final Logger _logger;
  final TimezoneLoader _loadTimezone;

  Future<String> resolve() async {
    if (debugOverride != null && debugOverride!.isNotEmpty) {
      _logger.info(
        'Using debug override timezone=${debugOverride!}',
        tag: _logTag,
      );
      return debugOverride!;
    }

    try {
      final value = (await _loadTimezone()).trim();
      if (_ianaRegex.hasMatch(value)) {
        _logger.debug('resolvedTimezoneIana=$value', tag: _logTag);
        return value;
      }

      _logger.warn(
        'Invalid timezone from platform: $value; falling back to UTC',
        tag: _logTag,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to resolve timezone; falling back to UTC',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }

    _logger.debug('resolvedTimezoneIana=UTC', tag: _logTag);
    return 'UTC';
  }
}
