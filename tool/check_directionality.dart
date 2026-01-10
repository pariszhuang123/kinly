import 'dart:io';

/// Fails if LTR-only layout APIs are found in lib/.
/// Run: dart run tool/check_directionality.dart

void main() {
  final root = Directory('lib');
  if (!root.existsSync()) {
    stderr.writeln('lib/ not found');
    exit(1);
  }

  final patterns = <_Lint>[
    _Lint(
      RegExp(r'EdgeInsets\.fromLTRB'),
      'Use EdgeInsetsDirectional.fromSTEB',
    ),
    _Lint(
      RegExp(r'EdgeInsets\.only\(\s*(left|right):'),
      'Use EdgeInsetsDirectional.only(start/end)',
    ),
    _Lint(
      RegExp(r'Alignment\.centerLeft|Alignment\.centerRight'),
      'Use AlignmentDirectional.centerStart/centerEnd',
    ),
    _Lint(
      RegExp(r'Positioned\(([^)]*\bleft:|[^)]*\bright:)'),
      'Use PositionedDirectional',
    ),
  ];

  final failures = <String>[];

  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    // Skip generated localization/codegen.
    if (entity.path.contains('lib/generated/')) continue;

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (final lint in patterns) {
        if (lint.pattern.hasMatch(line)) {
          failures.add('${entity.path}:${i + 1}: ${lint.message}');
          break;
        }
      }
    }
  }

  if (failures.isEmpty) {
    stdout.writeln('Directionality check passed.');
    return;
  }

  stderr.writeln('Directionality issues found:');
  for (final issue in failures) {
    stderr.writeln(' - $issue');
  }
  exit(1);
}

class _Lint {
  _Lint(this.pattern, this.message);
  final RegExp pattern;
  final String message;
}
