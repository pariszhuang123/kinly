import 'dart:io';

// ignore_for_file: prefer_interpolation_to_compose_strings

/// Generates a testing pyramid report showing test distribution by type.
///
/// Categories:
/// - Unit tests: contracts/, core/ (models, mappers, utilities, forms)
/// - BLoC tests: *_bloc_test.dart, *_cubit_test.dart
/// - Widget tests: *_screen_test.dart, *_view_test.dart, widget tests
/// - Integration tests: test/integration/
/// - pgTAP tests: supabase/tests/*.sql (RLS + RPC)
/// - Deno tests: supabase/functions/**/*_test.ts (Edge functions)
///
/// Run: dart run tool/check_test_pyramid.dart
void main() async {
  final testDir = Directory('test');
  if (!testDir.existsSync()) {
    stderr.writeln('Error: test/ directory not found');
    exitCode = 1;
    return;
  }

  final testFiles =
      testDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_test.dart'))
          .toList();

  final counts = _TestCounts();

  for (final file in testFiles) {
    final relativePath = file.path.replaceAll('\\', '/');
    final content = file.readAsStringSync();
    final testCount = _countTests(content);

    if (relativePath.contains('/integration/')) {
      counts.integration += testCount;
      counts.integrationFiles++;
    } else if (relativePath.contains('_bloc_test.dart') ||
        relativePath.contains('_cubit_test.dart')) {
      counts.bloc += testCount;
      counts.blocFiles++;
    } else if (relativePath.contains('_screen_test.dart') ||
        relativePath.contains('_view_test.dart') ||
        _isWidgetTest(content)) {
      counts.widget += testCount;
      counts.widgetFiles++;
    } else if (relativePath.contains('/contracts/') ||
        relativePath.contains('/core/') ||
        relativePath.contains('/domain/')) {
      counts.unit += testCount;
      counts.unitFiles++;
    } else {
      // Default to widget tests for feature UI tests
      if (relativePath.contains('/features/') &&
          relativePath.contains('/ui/')) {
        counts.widget += testCount;
        counts.widgetFiles++;
      } else {
        counts.unit += testCount;
        counts.unitFiles++;
      }
    }
  }

  // Count pgTAP tests (supabase/tests/*.sql)
  final pgTapDir = Directory('supabase/tests');
  if (pgTapDir.existsSync()) {
    final pgTapFiles =
        pgTapDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sql'))
            .toList();
    counts.pgtapFiles = pgTapFiles.length;
    for (final file in pgTapFiles) {
      final content = file.readAsStringSync();
      counts.pgtap += _countPgTapTests(content);
    }
  }

  // Count Deno tests (supabase/functions/**/*_test.ts or *.test.ts)
  final functionsDir = Directory('supabase/functions');
  if (functionsDir.existsSync()) {
    final denoFiles =
        functionsDir
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (f) => f.path.endsWith('_test.ts') || f.path.endsWith('.test.ts'),
            )
            .toList();
    counts.denoFiles = denoFiles.length;
    for (final file in denoFiles) {
      final content = file.readAsStringSync();
      counts.deno += _countDenoTests(content);
    }
  }

  _printReport(counts, testFiles.length);
}

int _countTests(String content) {
  // Count test(), testWidgets(), and blocTest() calls
  final testPattern = RegExp(r"\btest\s*\(|testWidgets\s*\(|blocTest\s*[<(]");
  return testPattern.allMatches(content).length;
}

int _countPgTapTests(String content) {
  // pgTAP uses SELECT plan(N) to declare N tests
  final planPattern = RegExp(r"SELECT\s+plan\s*\(\s*(\d+)\s*\)");
  final match = planPattern.firstMatch(content);
  if (match != null) {
    return int.tryParse(match.group(1) ?? '0') ?? 0;
  }
  return 0;
}

int _countDenoTests(String content) {
  // Deno uses Deno.test("...", ...)
  final denoTestPattern = RegExp(r'Deno\.test\s*\(');
  return denoTestPattern.allMatches(content).length;
}

bool _isWidgetTest(String content) {
  return content.contains('testWidgets(') ||
      content.contains('pumpWidget') ||
      content.contains('WidgetTester');
}

void _printReport(_TestCounts counts, int totalFiles) {
  final flutterTotal =
      counts.unit + counts.bloc + counts.widget + counts.integration;
  final grandTotal = flutterTotal + counts.pgtap + counts.deno;

  stdout.writeln('');
  stdout.writeln(
    '╔═══════════════════════════════════════════════════════════════╗',
  );
  stdout.writeln(
    '║                  TESTING PYRAMID REPORT                       ║',
  );
  stdout.writeln(
    '╠═══════════════════════════════════════════════════════════════╣',
  );
  stdout.writeln(
    '║                                                               ║',
  );
  stdout.writeln(
    '║  ┌─────────────────────────────────────────────────────────┐  ║',
  );
  stdout.writeln(
    '║  │  FLUTTER TESTS (test/)                                  │  ║',
  );
  stdout.writeln(
    '║  └─────────────────────────────────────────────────────────┘  ║',
  );

  // Integration (top)
  final intPct =
      flutterTotal > 0 ? (counts.integration / flutterTotal * 100) : 0;
  stdout.writeln(
    '║                      ▲ Integration                            ║',
  );
  stdout.writeln(
    '║                     ╱ ╲  ${counts.integration.toString().padLeft(4)} tests (${intPct.toStringAsFixed(1).padLeft(5)}%)              ║',
  );
  stdout.writeln(
    '║                    ╱   ╲ ${counts.integrationFiles.toString().padLeft(4)} files                       ║',
  );

  // Widget (middle)
  final widgetPct = flutterTotal > 0 ? (counts.widget / flutterTotal * 100) : 0;
  stdout.writeln(
    '║                   ╱─────╲                                     ║',
  );
  stdout.writeln(
    '║                  ╱ Widget╲ ${counts.widget.toString().padLeft(4)} tests (${widgetPct.toStringAsFixed(1).padLeft(5)}%)             ║',
  );
  stdout.writeln(
    '║                 ╱         ╲${counts.widgetFiles.toString().padLeft(4)} files                       ║',
  );

  // BLoC (middle-lower)
  final blocPct = flutterTotal > 0 ? (counts.bloc / flutterTotal * 100) : 0;
  stdout.writeln(
    '║                ╱───────────╲                                  ║',
  );
  stdout.writeln(
    '║               ╱    BLoC     ╲${counts.bloc.toString().padLeft(4)} tests (${blocPct.toStringAsFixed(1).padLeft(5)}%)            ║',
  );
  stdout.writeln(
    '║              ╱               ╲${counts.blocFiles.toString().padLeft(4)} files                      ║',
  );

  // Unit (base)
  final unitPct = flutterTotal > 0 ? (counts.unit / flutterTotal * 100) : 0;
  stdout.writeln(
    '║             ╱─────────────────╲                               ║',
  );
  stdout.writeln(
    '║            ╱       Unit        ╲${counts.unit.toString().padLeft(4)} tests (${unitPct.toStringAsFixed(1).padLeft(5)}%)           ║',
  );
  stdout.writeln(
    '║           ╱                     ╲${counts.unitFiles.toString().padLeft(4)} files                     ║',
  );
  stdout.writeln(
    '║          ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔                            ║',
  );

  stdout.writeln(
    '║                                                               ║',
  );
  stdout.writeln(
    '║  ┌─────────────────────────────────────────────────────────┐  ║',
  );
  stdout.writeln(
    '║  │  BACKEND TESTS (supabase/)                              │  ║',
  );
  stdout.writeln(
    '║  └─────────────────────────────────────────────────────────┘  ║',
  );
  stdout.writeln(
    '║    pgTAP (RLS/RPC):  ${counts.pgtap.toString().padLeft(4)} tests across ${counts.pgtapFiles.toString().padLeft(2)} files              ║',
  );
  stdout.writeln(
    '║    Deno (Edge Fn):   ${counts.deno.toString().padLeft(4)} tests across ${counts.denoFiles.toString().padLeft(2)} files              ║',
  );

  stdout.writeln(
    '║                                                               ║',
  );
  stdout.writeln(
    '╠═══════════════════════════════════════════════════════════════╣',
  );
  stdout.writeln(
    '║  FLUTTER: $flutterTotal tests across $totalFiles files'.padRight(64) +
        '║',
  );
  stdout.writeln(
    '║  BACKEND: ${counts.pgtap + counts.deno} tests across ${counts.pgtapFiles + counts.denoFiles} files'
            .padRight(64) +
        '║',
  );
  stdout.writeln('║  GRAND TOTAL: $grandTotal tests'.padRight(64) + '║');
  stdout.writeln(
    '╚═══════════════════════════════════════════════════════════════╝',
  );
  stdout.writeln('');

  // Health indicators
  stdout.writeln('Health Check:');
  if (unitPct >= 50) {
    stdout.writeln(
      '  ✓ Unit tests form the base (${unitPct.toStringAsFixed(1)}% >= 50%)',
    );
  } else {
    stdout.writeln(
      '  ✗ Unit tests should be >= 50% (currently ${unitPct.toStringAsFixed(1)}%)',
    );
  }

  if (intPct <= 10) {
    stdout.writeln(
      '  ✓ Integration tests are focused (${intPct.toStringAsFixed(1)}% <= 10%)',
    );
  } else {
    stdout.writeln(
      '  ! Integration tests may be heavy (${intPct.toStringAsFixed(1)}% > 10%)',
    );
  }

  final unitBlocRatio = counts.bloc > 0 ? counts.unit / counts.bloc : 0;
  if (unitBlocRatio >= 1) {
    stdout.writeln(
      '  ✓ Good unit-to-BLoC ratio (${unitBlocRatio.toStringAsFixed(1)}:1)',
    );
  } else {
    stdout.writeln(
      '  ! Consider more unit tests (ratio ${unitBlocRatio.toStringAsFixed(1)}:1)',
    );
  }

  if (counts.pgtap > 0) {
    stdout.writeln('  ✓ pgTAP RLS/RPC tests present (${counts.pgtap} tests)');
  } else {
    stdout.writeln('  ✗ No pgTAP tests found');
  }

  if (counts.deno > 0) {
    stdout.writeln(
      '  ✓ Deno edge function tests present (${counts.deno} tests)',
    );
  } else {
    stdout.writeln('  ! No Deno tests found for edge functions');
  }
}

class _TestCounts {
  int unit = 0;
  int unitFiles = 0;
  int bloc = 0;
  int blocFiles = 0;
  int widget = 0;
  int widgetFiles = 0;
  int integration = 0;
  int integrationFiles = 0;
  int pgtap = 0;
  int pgtapFiles = 0;
  int deno = 0;
  int denoFiles = 0;
}
