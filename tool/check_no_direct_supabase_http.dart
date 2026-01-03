import 'dart:io';

final _supabasePattern = RegExp(r'package:(supabase|supabase_flutter)/');
final _httpPattern = RegExp(r'package:http/');

void main() {
  final violations = <String>[];
  final dirs = ['lib/features'];

  for (final dir in dirs) {
    for (final file in _dartFilesUnder(dir)) {
      if (_isGenerated(file)) continue;
      final normalized = file.path.replaceAll('\\', '/');
      if (!_isUiOrBloc(normalized)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('import')) continue;
        final importPath = _extractImportPath(line);
        if (importPath == null) continue;
        if (_supabasePattern.hasMatch(importPath) ||
            _httpPattern.hasMatch(importPath)) {
          violations.add(
            '$normalized:${i + 1} UI/BLoC must not import Supabase or HTTP ($importPath)',
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No Supabase/HTTP in UI/BLoC guardrails passed');
    return;
  }

  stdout.writeln(
    'No Supabase/HTTP in UI/BLoC guardrails failed (${violations.length}):',
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

bool _isUiOrBloc(String path) {
  return path.contains('/ui/') || path.contains('/bloc/');
}

String? _extractImportPath(String line) {
  final start = line.indexOf("'");
  final end = line.lastIndexOf("'");
  if (start == -1 || end == -1 || end <= start) return null;
  return line.substring(start + 1, end);
}
