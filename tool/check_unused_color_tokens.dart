import 'dart:io';

/// Fails if any color token declared in lib/core/theme/color_tokens.dart
/// is not referenced outside that file.
void main() async {
  final tokensFile = File('lib/core/theme/color_tokens.dart');
  if (!tokensFile.existsSync()) {
    stderr.writeln('color_tokens.dart not found');
    exit(1);
  }

  final content = tokensFile.readAsLinesSync();
  final tokenRegex = RegExp(r'final Color (\w+);');
  final tokens = <String>[];
  for (final line in content) {
    final m = tokenRegex.firstMatch(line);
    if (m != null) tokens.add(m.group(1)!);
  }

  final unused = <String>[];
  for (final name in tokens) {
    final result = await Process.run(
      'rg',
      [
        '--no-heading',
        '--word-regexp',
        name,
        'lib',
        '--glob',
        '!lib/core/theme/color_tokens.dart',
      ],
    );
    if (result.exitCode == 1 || (result.stdout as String).trim().isEmpty) {
      unused.add(name);
    }
  }

  if (unused.isNotEmpty) {
    stderr.writeln('Unused color tokens: ${unused.join(', ')}');
    exit(1);
  }

  stdout.writeln('All color tokens are referenced.');
}
