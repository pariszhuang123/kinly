import 'dart:io';

final _routeNameDecl = RegExp(r'static const ([a-zA-Z0-9_]+)\s*=');

void main() {
  final violations = <String>[];
  final appRouteNames = _loadAppRouteNames(
    'lib/app/router/app_route_names.dart',
  );
  if (appRouteNames.isEmpty) {
    stdout.writeln('Route name usage guardrails skipped (no AppRouteNames).');
    return;
  }

  final routeFiles = [
    ..._dartFilesUnder('lib/features'),
    ..._dartFilesUnder('lib/foundation'),
  ].where(
    (f) =>
        f.path.contains(
          '${Platform.pathSeparator}routes${Platform.pathSeparator}',
        ) &&
        f.path.endsWith('.dart'),
  );

  final usedNames = <String>{};
  for (final file in routeFiles) {
    final content = file.readAsStringSync();
    for (final name in appRouteNames) {
      if (content.contains('AppRouteNames.$name')) {
        usedNames.add(name);
      }
    }
  }

  final missing = appRouteNames.difference(usedNames).toList()..sort();
  for (final name in missing) {
    violations.add('AppRouteNames.$name is not used in any routes file');
  }

  if (violations.isEmpty) {
    stdout.writeln('Route name usage guardrails passed');
    return;
  }

  stdout.writeln('Route name usage guardrails failed (${violations.length}):');
  for (final v in violations) {
    stdout.writeln(' - $v');
  }
  exitCode = 1;
}

Set<String> _loadAppRouteNames(String path) {
  final file = File(path);
  if (!file.existsSync()) return {};
  final names = <String>{};
  for (final line in file.readAsLinesSync()) {
    final match = _routeNameDecl.firstMatch(line);
    if (match != null) {
      names.add(match.group(1)!);
    }
  }
  return names;
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
