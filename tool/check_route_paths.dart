import 'dart:io';

void main() {
  final violations = <String>[];
  final nonRouteFiles =
      _dartFilesUnder('lib').where((f) => !_isRoutesFile(f)).toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final files =
      [
        ..._dartFilesUnder('lib/features'),
        ..._dartFilesUnder('lib/foundation'),
      ]
          .where(
            (f) =>
                f.path.contains(
                  '${Platform.pathSeparator}routes${Platform.pathSeparator}',
                ) &&
                f.path.endsWith('.dart'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in nonRouteFiles) {
    _checkGoRouteUsage(file, violations);
  }
  for (final file in files) {
    _checkFile(file, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('Route path guardrails passed');
    return;
  }

  stdout.writeln('Route path guardrails failed (${violations.length}):');
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

bool _isRoutesFile(File file) {
  final path = file.path;
  return path.contains(
        '${Platform.pathSeparator}routes${Platform.pathSeparator}',
      ) &&
      path.endsWith('.dart');
}

void _checkGoRouteUsage(File file, List<String> violations) {
  final path = file.path.replaceAll('\\', '/');
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('GoRoute(')) {
      violations.add(
        '$path:${i + 1} GoRoute must be declared in routes/ files only',
      );
    }
  }
}

void _checkFile(File file, List<String> violations) {
  final path = file.path.replaceAll('\\', '/');
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (!line.contains('path:')) continue;
    if (line.contains('AppRoutePaths.')) continue;
    violations.add(
      '$path:${i + 1} route path must use AppRoutePaths (no literals or AppRoutes)',
    );
  }
}
