import 'dart:io';

final _writePatterns = <RegExp>[
  RegExp(r'\.insert\s*\('),
  RegExp(r'\.update\s*\('),
  RegExp(r'\.delete\s*\('),
  RegExp(r'\.upsert\s*\('),
];
final _supabaseImport = RegExp(r'^package:(supabase|supabase_flutter)/');

void main() {
  final violations = <String>[];
  for (final file in _dartFilesUnder('lib')) {
    if (_isGenerated(file)) continue;
    final normalized = file.path.replaceAll('\\', '/');
    final lines = file.readAsLinesSync();
    if (!_importsSupabase(lines)) {
      continue;
    }
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (final pattern in _writePatterns) {
        if (pattern.hasMatch(line)) {
          violations.add(
            '$normalized:${i + 1} direct writes are not allowed; use approved RPCs',
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No direct writes guardrails passed');
    return;
  }

  stdout.writeln('No direct writes guardrails failed (${violations.length}):');
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

bool _importsSupabase(List<String> lines) {
  for (final line in lines) {
    if (!line.trim().startsWith('import')) continue;
    final importPath = _extractImportPath(line);
    if (importPath == null) continue;
    if (_supabaseImport.hasMatch(importPath)) return true;
  }
  return false;
}

String? _extractImportPath(String line) {
  final start = line.indexOf("'");
  final end = line.lastIndexOf("'");
  if (start == -1 || end == -1 || end <= start) return null;
  return line.substring(start + 1, end);
}
