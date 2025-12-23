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
        _loadTimezone = loader ?? FlutterTimezone.getLocalTimezone;

  static const _logTag = 'Timezone';
  static final _ianaRegex =
      RegExp(r'^[A-Za-z_]+(?:/[A-Za-z_]+)+$|^UTC$', multiLine: false);

  final Logger _logger;
  final TimezoneLoader _loadTimezone;

  Future<String> resolve() async {
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
