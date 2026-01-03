import 'dart:io';

const _dartIoImport = 'dart:io';
const _platformAccess = 'Platform.';
const _defaultTargetPlatform = 'defaultTargetPlatform';
const _kIsWeb = 'kIsWeb';

void main() {
  final violations = <String>[];
  final roots = ['lib/features', 'lib/foundation'];

  for (final root in roots) {
    for (final file in _dartFilesUnder(root)) {
      if (_isGenerated(file)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (_containsDartIoImport(line) ||
            line.contains(_platformAccess) ||
            line.contains(_defaultTargetPlatform) ||
            line.contains(_kIsWeb)) {
          violations.add(
            '${file.path.replaceAll('\\', '/')}:${i + 1} '
            'platform-specific logic is not allowed in features/foundation',
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No-platform-logic guardrails passed');
    return;
  }

  stdout.writeln(
    'No-platform-logic guardrails failed (${violations.length}):',
  );
  for (final v in violations) {
    stdout.writeln(' - $v');
  }
  exitCode = 1;
}

Iterable<File> _dartFilesUnder(String root) sync* {
  final rootDir = Directory(root);
  if (!rootDir.existsSync()) return;
  for (final entry in rootDir.listSync(recursive: true, followLinks: false)) {
    if (entry is File && entry.path.endsWith('.dart')) {
      yield entry;
    }
  }
}

bool _containsDartIoImport(String line) {
  final trimmed = line.trimLeft();
  return trimmed.startsWith('import') && trimmed.contains(_dartIoImport);
}

bool _isGenerated(File file) {
  final path = file.path.replaceAll('\\', '/');
  return path.contains('/generated/') ||
      path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart');
}
