import 'dart:io';

/// Simple guardrail that ensures shared enums inside lib/core live under
/// lib/core/<domain>/enums so each agent can locate and version contracts.
Future<void> main(List<String> args) async {
  final projectRoot = Directory.current;
  final libCore = Directory('${projectRoot.path}${Platform.pathSeparator}lib${Platform.pathSeparator}core');
  if (!libCore.existsSync()) {
    stdout.writeln('No lib/core directory found; skipping enum check.');
    return;
  }

  final violations = <String>[];
  final enumPattern = RegExp(r'\benum\s+\w+\s*{', multiLine: true);

  for (final entity in libCore.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final normalizedPath = entity.path.replaceAll('\\', '/');

    if (normalizedPath.contains('/enums/')) continue;

    final contents = entity.readAsStringSync();
    if (enumPattern.hasMatch(contents)) {
      violations.add(normalizedPath);
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Enum ownership check passed.');
    return;
  }

  stderr.writeln(
    'Shared enums must live under lib/core/<domain>/enums. '
    'Move the enums in these files:\n${violations.map((v) => ' - $v').join('\n')}',
  );
  exitCode = 1;
}
