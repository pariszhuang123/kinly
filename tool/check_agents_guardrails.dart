import 'dart:io';

final _checkCommand = RegExp(r'dart run tool/check_[a-zA-Z0-9_]+\.dart');
const _allowedCheck = 'dart run tool/check_all.dart';
const _requiredNote =
    'If you add a new guardrail, add it to `check_all.dart` (and only that).';

void main() {
  final file = File('AGENTS.md');
  if (!file.existsSync()) {
    stdout.writeln('AGENTS.md not found, skipping guardrails check.');
    return;
  }

  final content = file.readAsStringSync();
  final violations = <String>[];

  for (final match in _checkCommand.allMatches(content)) {
    final value = match.group(0)!;
    if (value != _allowedCheck) {
      violations.add('AGENTS.md contains disallowed check command: $value');
    }
  }

  if (!content.contains(_requiredNote)) {
    violations.add('AGENTS.md must include the guardrail note: $_requiredNote');
  }

  if (violations.isEmpty) {
    stdout.writeln('AGENTS guardrails passed');
    return;
  }

  stdout.writeln('AGENTS guardrails failed (${violations.length}):');
  for (final v in violations) {
    stdout.writeln(' - $v');
  }
  exitCode = 1;
}
