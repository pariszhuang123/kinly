import 'dart:io';

const _files = [
  'lib/foundation/surfaces/today/today_registry.dart',
  'lib/foundation/surfaces/today/widgets/today_invite_prompt.dart',
  'lib/foundation/surfaces/hub/widget/hub_preferences_list_screen.dart',
  'lib/foundation/surfaces/hub/widget/hub_preferences_section.dart',
  'lib/features/preferences/ui/preference_onboarding_screen.dart',
  'lib/features/preferences/ui/preference_onboarding_provider.dart',
  'lib/features/preferences/ui/preference_report_screen.dart',
  'lib/features/preferences/ui/preference_report_provider.dart',
  'lib/features/preferences/ui/preference_report_edit_screen.dart',
  'lib/features/preferences/ui/preference_report_edit_provider.dart',
  'lib/features/preferences/ui/preference_report_section_screen.dart',
];

const _needles = ['sections.preference', 'preferenceSection'];

void main() {
  final missing = <String>[];
  final warnings = <String, List<String>>{};

  for (final path in _files) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('ERROR: preference file missing: $path');
      exitCode = 1;
      continue;
    }

    final content = file.readAsStringSync();
    final hasNeedle = _needles.any(content.contains);
    if (!hasNeedle) {
      missing.add(path);
    }

    final fileWarnings = <String>[];
    if (content.contains('colorScheme.primary')) {
      fileWarnings.add('colorScheme.primary');
    }
    if (RegExp(r'Color\(0x', caseSensitive: false).hasMatch(content)) {
      fileWarnings.add('Color(0x');
    }
    if (fileWarnings.isNotEmpty) {
      warnings[path] = fileWarnings;
    }
  }

  if (warnings.isNotEmpty) {
    stdout.writeln('Preference palette warnings (non-blocking):');
    warnings.forEach((path, issues) {
      stdout.writeln(' - $path uses: ${issues.join(', ')}');
    });
    stdout.writeln('');
  }

  if (missing.isNotEmpty) {
    stderr.writeln(
      'Preference palette guard failed. Missing preference palette usage in:',
    );
    for (final path in missing) {
      stderr.writeln(' - $path');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Preference palette guard passed for all in-scope files.');
}
