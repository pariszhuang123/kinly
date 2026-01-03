import 'dart:io';

class _ForbiddenPattern {
  const _ForbiddenPattern(this.label, this.pattern);

  final String label;
  final RegExp pattern;
}

final _patterns = <_ForbiddenPattern>[
  _ForbiddenPattern('ElevatedButton', RegExp(r'\bElevatedButton\s*\(')),
  _ForbiddenPattern('TextButton', RegExp(r'\bTextButton\s*\(')),
  _ForbiddenPattern('OutlinedButton', RegExp(r'\bOutlinedButton\s*\(')),
  _ForbiddenPattern('MaterialButton', RegExp(r'\bMaterialButton\s*\(')),
  _ForbiddenPattern('RawMaterialButton', RegExp(r'\bRawMaterialButton\s*\(')),
  _ForbiddenPattern('FloatingActionButton', RegExp(r'\bFloatingActionButton\s*\(')),
  _ForbiddenPattern('CircularProgressIndicator', RegExp(r'\bCircularProgressIndicator\s*\(')),
  _ForbiddenPattern('SnackBar', RegExp(r'\bSnackBar\s*\(')),
  _ForbiddenPattern('AlertDialog', RegExp(r'\bAlertDialog\s*\(')),
  _ForbiddenPattern('BottomSheet', RegExp(r'\bBottomSheet\s*\(')),
  _ForbiddenPattern('TextField', RegExp(r'\bTextField\s*\(')),
  _ForbiddenPattern('DropdownButton', RegExp(r'\bDropdownButton\s*\(')),
  _ForbiddenPattern('Checkbox', RegExp(r'\bCheckbox\s*\(')),
  _ForbiddenPattern('Switch', RegExp(r'\bSwitch\s*\(')),
  _ForbiddenPattern('Radio', RegExp(r'\bRadio\s*\(')),
  _ForbiddenPattern('Slider', RegExp(r'\bSlider\s*\(')),
];

void main() {
  final violations = <String>[];
  final roots = ['lib/features', 'lib/foundation'];

  for (final root in roots) {
    for (final file in _dartFilesUnder(root)) {
      if (_isGenerated(file)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        for (final forbidden in _patterns) {
          if (forbidden.pattern.hasMatch(line)) {
            violations.add(
              '${file.path.replaceAll('\\', '/')}:${i + 1} '
              'raw ${forbidden.label} is not allowed; use Kinly primitives',
            );
          }
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('No-raw-material guardrails passed');
    return;
  }

  stdout.writeln('No-raw-material guardrails failed (${violations.length}):');
  for (final v in violations) {
    stdout.writeln(' - $v');
  }
  exitCode = 1;
}

Iterable<File> _dartFilesUnder(String root) sync* {
  final rootDir = Directory(root);
  if (!rootDir.existsSync()) return;
  for (final entry in rootDir.listSync(recursive: true, followLinks: false)) {
    if (entry is File && entry.path.endsWith('.dart')) {
      yield entry;
    }
  }
}

bool _isGenerated(File file) {
  final path = file.path.replaceAll('\\', '/');
  return path.contains('/generated/') ||
      path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart');
}
