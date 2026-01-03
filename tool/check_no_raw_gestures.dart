import 'dart:io';

final _patterns = <RegExp>[
  RegExp(r'\bInkWell\s*\('),
  RegExp(r'\bInkResponse\s*\('),
  RegExp(r'\bGestureDetector\s*\('),
  RegExp(r'\bRawGestureDetector\s*\('),
  RegExp(r'\bListener\s*\('),
];

void main() {
  final violations = <String>[];
  final roots = ['lib/features', 'lib/foundation'];

  for (final root in roots) {
    for (final file in _dartFilesUnder(root)) {
      if (_isGenerated(file)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        for (final pattern in _patterns) {
          if (pattern.hasMatch(line)) {
            violations.add(
              '${file.path.replaceAll('\\', '/')}:${i + 1} '
              'raw gesture widgets are not allowed; use Kinly primitives',
            );
          }
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No raw gesture guardrails passed');
    return;
  }

  stdout.writeln('No raw gesture guardrails failed (${violations.length}):');
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

bool _isGenerated(File file) {
  final path = file.path.replaceAll('\\', '/');
  return path.contains('/generated/') ||
      path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart');
}
