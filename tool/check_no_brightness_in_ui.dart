import 'dart:io';

void main(List<String> args) async {
  final allowList = [
    'lib/core/theme',
    'lib/core/dopamine/dopamine_overlay.dart',
    'lib/core/theme/kinly_palette.dart',
    'lib/core/theme/kinly_theme.dart',
    'lib/core/theme/typography_tokens.dart',
  ];

  // Directories to scan for forbidden brightness checks.
  final targets = ['lib/core/ui', 'lib/features'];

  // Build ripgrep command.
  final rgArgs = [
    'rg',
    r'Brightness\.dark',
    ...targets,
    ...allowList.expand((path) => ['--glob', '!$path']),
  ];

  final result = await Process.run(rgArgs.first, rgArgs.skip(1).toList());

  if (result.exitCode == 0) {
    // Matches found; report and fail.
    stderr.writeln('Found forbidden Brightness.dark checks:');
    stderr.writeln(result.stdout);
    exit(1);
  } else if (result.exitCode == 1) {
    // No matches found.
    stdout.writeln('No Brightness.dark usage found in UI/primitives.');
  } else {
    // rg not found or error.
    stderr.writeln('Failed to run ripgrep. Install rg to use this check.');
    stderr.writeln(result.stderr);
    exit(result.exitCode);
  }
}
