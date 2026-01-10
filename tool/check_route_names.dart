import 'dart:io';

final _goRouteStart = RegExp(r'\bGoRoute\s*\(');
final _goRouteEnd = RegExp(r'\)\s*,?\s*$');
final _nameLine = RegExp(r'\bname\s*:\s*');
final _appRouteNames = RegExp(r'\bAppRouteNames\.');

void main() {
  final violations = <String>[];
  final files =
      [..._dartFilesUnder('lib/features'), ..._dartFilesUnder('lib/foundation')]
          .where(
            (f) =>
                f.path.contains(
                  '${Platform.pathSeparator}routes${Platform.pathSeparator}',
                ) &&
                f.path.endsWith('.dart'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    _checkFile(file, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('Route name guardrails passed');
    return;
  }

  stdout.writeln('Route name guardrails failed (${violations.length}):');
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

void _checkFile(File file, List<String> violations) {
  final path = file.path.replaceAll('\\', '/');
  final lines = file.readAsLinesSync();
  var inRoute = false;
  var nameLineIndex = -1;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (!inRoute && _goRouteStart.hasMatch(line)) {
      inRoute = true;
      nameLineIndex = -1;
      continue;
    }

    if (inRoute) {
      if (_nameLine.hasMatch(line)) {
        nameLineIndex = i;
        if (!_appRouteNames.hasMatch(line)) {
          violations.add('$path:${i + 1} GoRoute name must use AppRouteNames');
        }
      }

      if (_goRouteEnd.hasMatch(line)) {
        if (nameLineIndex == -1) {
          violations.add(
            '$path:${i + 1} GoRoute must define name using AppRouteNames',
          );
        }
        inRoute = false;
        nameLineIndex = -1;
      }
    }
  }
}
