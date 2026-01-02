import 'dart:io';

final _contextGo =
    RegExp(r'\bcontext\.go\s*\(');
final _contextPush =
    RegExp(r'\bcontext\.push\s*\(');
final _contextPushGeneric =
    RegExp(r'\bcontext\.push\s*<[^>]+>\s*\(');
final _contextGoNamed =
    RegExp(r'\bcontext\.goNamed\s*\(');
final _contextPushNamed =
    RegExp(r'\bcontext\.pushNamed\s*\(');
final _routerGo =
    RegExp(r'\bGoRouter\.of\(\s*context\s*\)\.go\s*\(');
final _routerPush =
    RegExp(r'\bGoRouter\.of\(\s*context\s*\)\.push\s*\(');
final _routerGoNamed =
    RegExp(r'\bGoRouter\.of\(\s*context\s*\)\.goNamed\s*\(');
final _routerPushNamed =
    RegExp(r'\bGoRouter\.of\(\s*context\s*\)\.pushNamed\s*\(');
final _navigatorPush =
    RegExp(r'\bNavigator\.of\(\s*context\s*\)\.push\b');
final _materialRoute =
    RegExp(r'\bMaterialPageRoute\b');
final _namedStringLiteral =
    RegExp('\\b(goNamed|pushNamed)\\s*\\(\\s*[\'"]');

void main() {
  final violations = <String>[];
  final files =
      _dartFilesUnder('lib').where((f) => !_isGenerated(f)).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    _checkFile(file, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('Named-route guardrails passed');
    return;
  }

  stdout.writeln('Named-route guardrails failed (${violations.length}):');
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

void _checkFile(File file, List<String> violations) {
  final path = file.path.replaceAll('\\', '/');
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (_contextGo.hasMatch(line) ||
        _contextPushGeneric.hasMatch(line) ||
        _contextPush.hasMatch(line) ||
        _routerGo.hasMatch(line) ||
        _routerPush.hasMatch(line) ||
        _navigatorPush.hasMatch(line) ||
        _materialRoute.hasMatch(line)) {
      violations.add(
        '$path:${i + 1} use goNamed/pushNamed and AppRouteNames (no raw path navigation)',
      );
      continue;
    }

    if ((_contextGoNamed.hasMatch(line) || _contextPushNamed.hasMatch(line)) &&
        _namedStringLiteral.hasMatch(line)) {
      violations.add(
        '$path:${i + 1} goNamed/pushNamed must use AppRouteNames (no string literals)',
      );
      continue;
    }

    if ((_routerGoNamed.hasMatch(line) || _routerPushNamed.hasMatch(line)) &&
        _namedStringLiteral.hasMatch(line)) {
      violations.add(
        '$path:${i + 1} goNamed/pushNamed must use AppRouteNames (no string literals)',
      );
    }
  }
}
