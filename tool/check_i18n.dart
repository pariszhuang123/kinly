import 'dart:io';

/// Simple guard rail to ensure UI surfaces don't reintroduce hard-coded strings.
/// Looks for Text/TextSpan literals across lib/ (excluding generated/localization
/// outputs) and fails if any are detected.
Future<void> main(List<String> args) async {
  final repoRoot = Directory.current.path;
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Unable to locate lib/ from $repoRoot');
    exit(1);
  }

  final skippedSegments = <String>[
    '${Platform.pathSeparator}generated${Platform.pathSeparator}',
    '${Platform.pathSeparator}l10n${Platform.pathSeparator}',
  ];

  final violations = <_Violation>[];
  await for (final entity
      in libDir.list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final normalizedPath = entity.path.replaceAll('\\', '/');
    if (skippedSegments.any(normalizedPath.contains)) continue;

    final lines = await entity.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final sanitized = line.split('//').first;
      final violation =
          _detectViolation(sanitized, normalizedPath, i + 1);
      if (violation != null) {
        violations.add(violation);
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('✓ No naked UI strings detected.');
    return;
  }

  stderr.writeln(
    'Found ${violations.length} potential naked string(s) in UI widgets.\n'
    'Localize them via lib/l10n/* and use S.of(context).',
  );
  for (final violation in violations) {
    stderr.writeln(
      '- ${violation.path}:${violation.line} → ${violation.message}',
    );
    stderr.writeln('    ${violation.snippet.trim()}');
  }
  exit(2);
}

_Violation? _detectViolation(String line, String path, int lineNumber) {
  final trimmed = line.trim();
  if (trimmed.isEmpty) return null;
  if (_isAllowedExpression(trimmed)) return null;

  for (final entry in _patterns.entries) {
    if (entry.key.hasMatch(trimmed)) {
      return _Violation(
        path: path,
        line: lineNumber,
        message: entry.value,
        snippet: line,
      );
    }
  }
  return null;
}

bool _isAllowedExpression(String line) {
  return line.contains('S.of(') ||
      line.contains('S.current') ||
      line.contains('LocalizationStrings.') ||
      line.contains("' '") ||
      line.contains('" "');
}

final Map<RegExp, String> _patterns = {
  RegExp(r'''(?:const\s+)?Text\(\s*["']'''): 'Text widget uses a raw string.',
  RegExp(r'''TextSpan\([^)]*text:\s*["']'''): 'TextSpan uses a raw string.',
  RegExp(r'''SnackBar\([^)]*content:\s*(?:const\s+)?Text\(\s*["']'''):
      'SnackBar content uses a raw string.',
};

class _Violation {
  const _Violation({
    required this.path,
    required this.line,
    required this.message,
    required this.snippet,
  });

  final String path;
  final int line;
  final String message;
  final String snippet;
}
