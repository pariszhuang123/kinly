/// Shared logging levels for every sink.
enum LogLevel { debug, info, warning, error }

extension LogLevelX on LogLevel {
  String get label => switch (this) {
        LogLevel.debug => 'DEBUG',
        LogLevel.info => 'INFO',
        LogLevel.warning => 'WARN',
        LogLevel.error => 'ERROR',
      };
}
