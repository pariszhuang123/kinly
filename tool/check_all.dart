import 'dart:async';
import 'dart:io';

class _Check {
  const _Check(this.name, this.command, this.args);

  final String name;
  final String command;
  final List<String> args;
}

bool _isCi() {
  final v = (Platform.environment['CI'] ?? '').toLowerCase().trim();
  return v == 'true' || v == '1' || v == 'yes';
}

Future<void> main() async {
  final checks = <_Check>[
    const _Check('check_test_guard', 'bash', ['tool/check_test_guard.sh']),
    const _Check('check_i18n', 'dart', ['run', 'tool/check_i18n.dart']),
    const _Check('l10n_integrity', 'dart', [
      'run',
      'tool/l10n_integrity_check.dart',
      'lib/l10n/intl_en.arb',
    ]),
    const _Check('check_enums', 'dart', ['run', 'tool/check_enums.dart']),
    const _Check('check_design_system', 'dart', [
      'run',
      'tool/check_design_system.dart',
      '--mode=fail',
    ]),
    const _Check('check_complexity_budget', 'dart', [
      'run',
      'tool/check_complexity_budget.dart',
    ]),
    const _Check('check_dependency_rules', 'dart', [
      'run',
      'tool/check_dependency_rules.dart',
    ]),
    const _Check('check_named_routes', 'dart', [
      'run',
      'tool/check_named_routes.dart',
    ]),
    const _Check('check_route_paths', 'dart', [
      'run',
      'tool/check_route_paths.dart',
    ]),
    const _Check('check_route_names', 'dart', [
      'run',
      'tool/check_route_names.dart',
    ]),
    const _Check('check_route_name_usage', 'dart', [
      'run',
      'tool/check_route_name_usage.dart',
    ]),
    const _Check('check_composable_system', 'dart', [
      'run',
      'tool/check_composable_system.dart',
      '--strict',
    ]),
    const _Check('check_nesting_depth', 'dart', [
      'run',
      'tool/check_nesting_depth.dart',
    ]),
    const _Check('check_directionality', 'dart', [
      'run',
      'tool/check_directionality.dart',
    ]),
    const _Check('check_copy_contract', 'dart', [
      'run',
      'tool/check_copy_contract.dart',
    ]),
    const _Check('check_shared_understanding_copy', 'dart', [
      'run',
      'tool/check_shared_understanding_copy.dart',
    ]),
    const _Check('contracts_extract', 'dart', [
      'run',
      'tool/contracts_extract.dart',
    ]),
    const _Check('check_contract_registry', 'dart', [
      'run',
      'tool/check_contract_registry.dart',
    ]),
    const _Check('check_agents_guardrails', 'dart', [
      'run',
      'tool/check_agents_guardrails.dart',
    ]),
    const _Check('check_no_prints', 'dart', [
      'run',
      'tool/check_no_prints.dart',
    ]),
    const _Check('check_no_direct_supabase_http', 'dart', [
      'run',
      'tool/check_no_direct_supabase_http.dart',
    ]),
    const _Check('check_no_raw_material', 'dart', [
      'run',
      'tool/check_no_raw_material.dart',
    ]),
    const _Check('check_no_platform_logic', 'dart', [
      'run',
      'tool/check_no_platform_logic.dart',
    ]),
    const _Check('check_no_public_invite_join_endpoints', 'dart', [
      'run',
      'tool/check_no_public_invite_join_endpoints.dart',
    ]),
    const _Check('check_no_direct_writes', 'dart', [
      'run',
      'tool/check_no_direct_writes.dart',
    ]),
    const _Check('check_no_raw_gestures', 'dart', [
      'run',
      'tool/check_no_raw_gestures.dart',
    ]),
    const _Check('check_preference_taxonomy', 'dart', [
      'run',
      'tool/check_preference_taxonomy.dart',
    ]),
    const _Check('check_preference_scenario_headings', 'dart', [
      'run',
      'tool/check_preference_scenarios_headings.dart',
    ]),
    const _Check('check_preference_report_language', 'dart', [
      'run',
      'tool/check_preference_reports_language.dart',
    ]),
    const _Check('check_preference_report_templates', 'dart', [
      'run',
      'tool/check_preference_report_templates.dart',
    ]),
    const _Check('check_home_dynamics_contract', 'dart', [
      'run',
      'tool/check_home_dynamics_contract.dart',
    ]),
    const _Check('check_di_wiring', 'dart', [
      'run',
      'tool/check_di_wiring.dart',
    ]),
    const _Check('check_colors', 'bash', ['tool/check_colors.sh']),
    const _Check('check_theme_tokens', 'dart', [
      'run',
      'tool/check_theme_tokens.dart',
    ]),
    const _Check('check_modules', 'dart', ['run', 'tool/check_modules.dart']),

    // --- Arch diagrams ---
    // Local dev: regenerate first so checks won't fail just because the diagram is stale.
    // CI: do not regenerate (no repo mutations). Only verify.
    if (!_isCi())
      const _Check('check_arch_diagrams_generate', 'python', [
        'tools/arch_diagram/generate.py',
      ]),
    const _Check('check_arch_diagrams', 'python', [
      'tools/arch_diagram/generate.py',
      '--check',
    ]),
  ];

  final results = await Future.wait(checks.map(_runCheck));
  final failed = results.where((result) => result.exitCode != 0).toList();

  if (failed.isEmpty) {
    stdout.writeln('All guardrail checks passed');
    return;
  }

  stdout.writeln('Guardrail checks failed (${failed.length}):');
  for (final result in failed) {
    stdout.writeln(' - ${result.name} (exit ${result.exitCode})');
  }

  stdout.writeln('\nFailure output:');
  for (final result in failed) {
    stdout.writeln('== ${result.name} ==');
    if (result.stdout.isNotEmpty) {
      stdout.writeln(result.stdout.trimRight());
    }
    if (result.stderr.isNotEmpty) {
      stdout.writeln(result.stderr.trimRight());
    }
  }

  exitCode = 1;
}

class _CheckResult {
  const _CheckResult({
    required this.name,
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final String name;
  final int exitCode;
  final String stdout;
  final String stderr;
}

Future<_CheckResult> _runCheck(_Check check) async {
  final process = await Process.start(
    check.command,
    check.args,
    runInShell: true,
  );

  final stdoutFuture =
      process.stdout.transform(const SystemEncoding().decoder).join();
  final stderrFuture =
      process.stderr.transform(const SystemEncoding().decoder).join();

  final exitCode = await process.exitCode;
  final stdoutText = await stdoutFuture;
  final stderrText = await stderrFuture;

  return _CheckResult(
    name: check.name,
    exitCode: exitCode,
    stdout: stdoutText,
    stderr: stderrText,
  );
}
