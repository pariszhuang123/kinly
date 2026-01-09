import 'dart:io';

class HomeDynamicsViolation {
  const HomeDynamicsViolation({
    required this.path,
    required this.line,
    required this.ruleId,
    required this.message,
  });

  final String path;
  final int line;
  final String ruleId;
  final String message;
}

List<HomeDynamicsViolation> findHomeDynamicsViolations({
  String rootPath = 'lib',
  String allowMarker = 'home-dynamics-allow',
}) {
  final violations = <HomeDynamicsViolation>[];
  final files = _dartFilesUnder(rootPath);
  for (final file in files) {
    if (_isGenerated(file)) continue;
    final normalized = file.path.replaceAll('\\', '/');
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains(allowMarker)) continue;
      if (_isVibeGating(line)) {
        violations.add(
          HomeDynamicsViolation(
            path: normalized,
            line: i + 1,
            ruleId: 'vibe-gating',
            message: 'Vibe must not gate or block actions.',
          ),
        );
      }
      if (_isVibeRulesDerivation(line)) {
        violations.add(
          HomeDynamicsViolation(
            path: normalized,
            line: i + 1,
            ruleId: 'vibe-rules-derive',
            message: 'Rules must not be auto-derived or updated from vibe.',
          ),
        );
      }
      if (_isPreferencesEnforcement(line)) {
        violations.add(
          HomeDynamicsViolation(
            path: normalized,
            line: i + 1,
            ruleId: 'preferences-enforcement',
            message: 'Preferences must not be enforced or used to gate.',
          ),
        );
      }
    }
  }
  return violations;
}

void main(List<String> args) {
  final rootPath = _readArg(args, '--root=') ?? 'lib';
  final allowMarker =
      _readArg(args, '--allow-marker=') ?? 'home-dynamics-allow';

  final violations = findHomeDynamicsViolations(
    rootPath: rootPath,
    allowMarker: allowMarker,
  );

  if (violations.isEmpty) {
    stdout.writeln('Home dynamics contract checks passed.');
    return;
  }

  stdout.writeln(
    'Home dynamics contract checks failed (${violations.length}):',
  );
  for (final v in violations) {
    stdout.writeln(' - ${v.path}:${v.line} ${v.ruleId} ${v.message}');
  }
  exitCode = 1;
}

Iterable<File> _dartFilesUnder(String rootPath) sync* {
  final type = FileSystemEntity.typeSync(rootPath);
  if (type == FileSystemEntityType.file) {
    final file = File(rootPath);
    if (file.path.endsWith('.dart')) yield file;
    return;
  }

  if (type != FileSystemEntityType.directory) return;
  final rootDir = Directory(rootPath);
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

bool _isVibeGating(String line) {
  return _vibeWord.hasMatch(line) && _gatingWords.hasMatch(line);
}

bool _isVibeRulesDerivation(String line) {
  return _vibeWord.hasMatch(line) &&
      _rulesWord.hasMatch(line) &&
      _derivationWords.hasMatch(line);
}

bool _isPreferencesEnforcement(String line) {
  return _preferencesWord.hasMatch(line) && _enforcementWords.hasMatch(line);
}

String? _readArg(List<String> args, String prefix) {
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      return arg.substring(prefix.length);
    }
  }
  return null;
}

final RegExp _vibeWord = RegExp(r'vibe', caseSensitive: false);
final RegExp _preferencesWord = RegExp(r'preference', caseSensitive: false);
final RegExp _rulesWord = RegExp(r'rules?', caseSensitive: false);
final RegExp _gatingWords = RegExp(
  r'\b(block|deny|gate|forbid|prevent|restrict|lock|redirect)\b',
  caseSensitive: false,
);
final RegExp _derivationWords = RegExp(
  r'\b(auto|derive|generate|sync|update|apply)\b',
  caseSensitive: false,
);
final RegExp _enforcementWords = RegExp(
  r'\b(enforce|require|must|block|deny|gate|forbid)\b',
  caseSensitive: false,
);
