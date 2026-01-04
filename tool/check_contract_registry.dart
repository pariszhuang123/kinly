import 'dart:async';
import 'dart:convert';
import 'dart:io';

class _StepResult {
  const _StepResult({
    required this.name,
    required this.exitCode,
    required this.stdoutText,
    required this.stderrText,
  });

  final String name;
  final int exitCode;
  final String stdoutText;
  final String stderrText;
}

Future<void> main() async {
  final steps = <_CheckStep>[
    const _CheckStep(
      'contracts_extract',
      'dart',
      ['run', 'tool/contracts_extract.dart'],
    ),
    const _CheckStep(
      'validate_registry',
      'dart',
      ['run', 'tool/validate_registry.dart', 'docs/contracts/registry.json'],
    ),
    const _CheckStep(
      'registry_diff',
      'git',
      ['diff', '--exit-code', 'docs/contracts/registry.json'],
    ),
  ];

  for (final step in steps) {
    final result = await _runStep(step);
    if (result.exitCode != 0) {
      _printFailure(result);
      exitCode = result.exitCode == 0 ? 1 : result.exitCode;
      return;
    }
  }
}

class _CheckStep {
  const _CheckStep(this.name, this.command, this.args);

  final String name;
  final String command;
  final List<String> args;
}

Future<_StepResult> _runStep(_CheckStep step) async {
  final process = await Process.start(
    step.command,
    step.args,
    runInShell: true,
  );

  final stdoutFuture = process.stdout
      .transform(utf8.decoder)
      .join();
  final stderrFuture = process.stderr
      .transform(utf8.decoder)
      .join();

  final exitCode = await process.exitCode;
  final stdoutText = await stdoutFuture;
  final stderrText = await stderrFuture;

  return _StepResult(
    name: step.name,
    exitCode: exitCode,
    stdoutText: stdoutText,
    stderrText: stderrText,
  );
}

void _printFailure(_StepResult result) {
  stdout.writeln('Contract registry check failed: ${result.name}');
  if (result.stdoutText.isNotEmpty) {
    stdout.writeln(result.stdoutText.trimRight());
  }
  if (result.stderrText.isNotEmpty) {
    stderr.writeln(result.stderrText.trimRight());
  }
}
