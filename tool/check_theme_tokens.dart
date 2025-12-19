import 'dart:io';

// Simple guard to catch common anti-patterns:
// - Null-aware access on required theme extensions (Spacing, Corners, KinlyOpacity, KinlyTypography).
// - Raw alpha literals in withValues(alpha: ...) instead of opacity tokens.
//
// This is intentionally light-weight and regex-based. If you need to allow a
// specific file/line, add a targeted ignore comment in code and update this
// script to whitelist it.

final _themeExtensionPatterns = [
  RegExp(r'extension<Spacing>\(\)\s*\?'),
  RegExp(r'extension<Corners>\(\)\s*\?'),
  RegExp(r'extension<KinlyOpacity>\(\)\s*\?'),
  RegExp(r'extension<KinlyTypography>\(\)\s*\?'),
];

// Matches withValues(alpha: 0.12) etc.
final _rawAlphaPattern = RegExp(r'withValues\s*\(\s*alpha:\s*\d+(\.\d+)?');

void main(List<String> args) {
  final root = Directory.current;
  final dartFiles = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      // Skip generated / tool / build outputs
      .where(
        (f) => !f.path.contains(
          RegExp(r'(/|\\\\)(build|\.dart_tool|tool)(/|\\\\)'),
        ),
      );

  final errors = <String>[];

  for (final file in dartFiles) {
    final content = file.readAsLinesSync();
    for (var i = 0; i < content.length; i++) {
      final line = content[i];
      for (final pattern in _themeExtensionPatterns) {
        if (pattern.hasMatch(line)) {
          errors.add('${file.path}:${i + 1}: avoid null-aware access on required theme extensions');
        }
      }
      if (_rawAlphaPattern.hasMatch(line)) {
        errors.add('${file.path}:${i + 1}: avoid raw alpha literals; use KinlyOpacity tokens');
      }
    }
  }

  if (errors.isNotEmpty) {
    stdout.writeln('Theme token guard found issues:');
    for (final err in errors) {
      stdout.writeln(' - $err');
    }
    exitCode = 1;
  }
}
