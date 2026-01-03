import 'dart:io';

final _printPattern = RegExp(r'\bprint\s*\(');
final _debugPrintPattern = RegExp(r'\bdebugPrint\s*\(');

void main() {
  final violations = <String>[];
  for (final file in _dartFilesUnder('lib')) {
    if (_isGenerated(file)) continue;
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (_printPattern.hasMatch(line) || _debugPrintPattern.hasMatch(line)) {
        violations.add(
          '${file.path.replaceAll('\\', '/')}:${i + 1} no print/debugPrint allowed (use Logger via DI)',
        );
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No-print guardrails passed');
    return;
  }

  stdout.writeln('No-print guardrails failed (${violations.length}):');
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
