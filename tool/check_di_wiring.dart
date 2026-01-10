import 'dart:io';

void main() {
  final violations = <String>[];
  final mainFile = File('lib/main.dart');
  final composeFile = File('lib/app/di/compose.dart');

  if (!composeFile.existsSync()) {
    violations.add('Missing lib/app/di/compose.dart');
  } else if (!_hasComposeDependencies(composeFile)) {
    violations.add('compose.dart must define composeDependencies()');
  }

  if (!mainFile.existsSync()) {
    violations.add('Missing lib/main.dart');
  } else {
    final content = mainFile.readAsStringSync();
    if (!content.contains("app/di/compose.dart")) {
      violations.add('main.dart must import app/di/compose.dart');
    }
    if (!content.contains('composeDependencies(')) {
      violations.add('main.dart must call composeDependencies()');
    }
  }

  for (final file in _dartFilesUnder('lib')) {
    final normalized = file.path.replaceAll('\\', '/');
    if (normalized == 'lib/main.dart' ||
        normalized == 'lib/app/di/compose.dart') {
      continue;
    }
    final content = file.readAsStringSync();
    if (content.contains('composeDependencies(')) {
      violations.add('$normalized must not call composeDependencies()');
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('DI wiring guardrails passed');
    return;
  }

  stdout.writeln('DI wiring guardrails failed (${violations.length}):');
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

bool _hasComposeDependencies(File file) {
  final content = file.readAsStringSync();
  return content.contains('composeDependencies(');
}
