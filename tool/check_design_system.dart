// Simple design system guardrail script.
// Flags common violations: raw Material widgets and hard-coded padding/colors in UI.
import 'dart:io';

final _forbiddenPatterns = <String, RegExp>{
  'Raw SnackBar': RegExp(r'[^A-Za-z]SnackBar\('),
  'Raw AlertDialog': RegExp(r'AlertDialog\('),
  'Raw showDialog': RegExp(r'showDialog<'),
  'Raw BottomSheet': RegExp(r'showModalBottomSheet'),
  'Raw TextField': RegExp(r'[^A-Za-z]TextField\('),
  'Raw ElevatedButton': RegExp(r'ElevatedButton\('),
  'Hard-coded EdgeInsets.all (non-zero)': RegExp(r'EdgeInsets\.all\((?!0\))'),
  'Hard-coded EdgeInsets.symmetric (non-zero)': RegExp(
    r'EdgeInsets\.symmetric\((?!vertical: 0|horizontal: 0)',
  ),
  'Hard-coded Color hex': RegExp(r'Color\(0x[0-9A-Fa-f]{6,8}\)'),
};

final _allowlistPaths = <String>['tool/', 'test/', 'lib/core/theme/'];

void main() {
  final repoRoot = Directory.current;
  final violations = <String>[];

  for (final file in repoRoot
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))) {
    final relativePath = file.path.replaceFirst(
      repoRoot.path + Platform.pathSeparator,
      '',
    );
    if (_allowlistPaths.any(relativePath.startsWith)) continue;

    final content = file.readAsStringSync();
    _forbiddenPatterns.forEach((label, pattern) {
      if (pattern.hasMatch(content)) {
        violations.add('$relativePath => $label');
      }
    });
  }

  if (violations.isEmpty) {
    stdout.writeln('Design system check passed ✅');
    return;
  }

  stderr.writeln('Design system violations found:');
  for (final v in violations) {
    stderr.writeln(' - $v');
  }
  exitCode = 1;
}
