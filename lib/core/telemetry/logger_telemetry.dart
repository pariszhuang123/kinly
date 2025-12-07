import '../logging/logger.dart';
import 'telemetry.dart';

/// Lightweight telemetry sink that routes events to the app logger.
class LoggerTelemetry implements Telemetry {
  LoggerTelemetry(this._logger);

  final Logger _logger;

  @override
  void track(String event, {Map<String, Object?> properties = const {}}) {
    _logger.info(
      'telemetry:$event ${properties.isNotEmpty ? properties.toString() : ''}',
      tag: 'telemetry',
    );
  }
}
