import 'dart:io';

final _inviteJoinPattern = RegExp(
  r'(invite|invites|join)',
  caseSensitive: false,
);
final _httpPattern = RegExp(r'http[s]?:\/\/');

void main() {
  final violations = <String>[];
  final roots = ['lib'];

  for (final root in roots) {
    for (final file in _dartFilesUnder(root)) {
      if (_isGenerated(file)) continue;
      final normalized = file.path.replaceAll('\\', '/');
      if (normalized.contains('/test/')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (_httpPattern.hasMatch(line) && _inviteJoinPattern.hasMatch(line)) {
          violations.add(
            '$normalized:${i + 1} no public invite/join endpoints in app code',
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No public invite/join endpoint guardrails passed');
    return;
  }

  stdout.writeln(
    'No public invite/join endpoint guardrails failed (${violations.length}):',
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

bool _isGenerated(File file) {
  final path = file.path.replaceAll('\\', '/');
  return path.contains('/generated/') ||
      path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart');
}
