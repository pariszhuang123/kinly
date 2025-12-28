import 'dart:convert';
import 'dart:io';

/// Verifies localization hygiene:
/// - All keys in the canonical EN ARB are referenced in lib/ (excluding generated files).
/// - All referenced keys exist in the canonical EN ARB.
/// - Optional: non-EN ARBs do not introduce keys that are absent from EN.
///
/// Notes:
/// - Supports references via:
///   - S.of(context).key
///   - S.current.key
///   - context.l10n.key
///   - Aliases such as:
///       final s = S.of(context);
///       final S s = S.of(context);
///       final s = context.l10n;
///   - Injected localization instances:
///       class Foo { final S s; ... }  // will treat "s.key" as a localization reference
void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    exit(0);
  }

  final enforceNonEn = args.contains('--enforce-non-en');
  final positional = args.where((arg) => !arg.startsWith('--')).toList();
  final arbPath =
      positional.isNotEmpty ? positional.first : 'lib/l10n/intl_en.arb';

  final arbFile = File(arbPath);
  if (!arbFile.existsSync()) {
    stderr.writeln('Canonical ARB not found at $arbPath');
    _printUsage();
    exit(1);
  }

  final canonicalKeys = _loadArbKeys(arbFile);
  if (canonicalKeys.isEmpty) {
    stderr.writeln('No localization keys found in $arbPath');
    exit(1);
  }

  final scanResult = _scanDartReferences();
  final referencedKeys = scanResult.references.map((ref) => ref.key).toSet();

  final unusedKeys = canonicalKeys.difference(referencedKeys).toList()..sort();
  final invalidReferences =
      scanResult.references
          .where((ref) => !canonicalKeys.contains(ref.key))
          .toList()
        ..sort((a, b) {
          final pathCompare = a.path.compareTo(b.path);
          if (pathCompare != 0) return pathCompare;
          return a.line.compareTo(b.line);
        });

  final nonEnExtras =
      enforceNonEn
          ? _findNonEnExtras(arbFile.parent, arbFile.path, canonicalKeys)
          : [];

  var hasFailure = false;

  if (unusedKeys.isNotEmpty) {
    hasFailure = true;
    stderr.writeln('Unused keys in ${arbFile.path}: ${unusedKeys.length}');
    for (final key in unusedKeys) {
      stderr.writeln('- $key');
    }
  }

  if (invalidReferences.isNotEmpty) {
    hasFailure = true;
    stderr.writeln(
      'Invalid localization references (missing from EN): ${invalidReferences.length}',
    );
    for (final ref in invalidReferences) {
      stderr.writeln('- ${ref.path}:${ref.line} -> ${ref.key}');
    }
  }

  if (nonEnExtras.isNotEmpty) {
    hasFailure = true;
    stderr.writeln('Non-EN ARBs contain keys not present in EN:');
    for (final drift in nonEnExtras) {
      stderr.writeln('- ${drift.path}: ${drift.extraKeys.length} extra key(s)');
      for (final key in drift.extraKeys) {
        stderr.writeln('  - $key');
      }
    }
  }

  if (hasFailure) {
    exit(2);
  }

  stdout.writeln('✓ Localization integrity check passed.');
  stdout.writeln('  Keys in EN: ${canonicalKeys.length}');
  stdout.writeln('  Referenced keys: ${referencedKeys.length}');
  if (enforceNonEn) {
    stdout.writeln('  Non-EN ARBs checked for extra keys: ok');
  }
}

void _printUsage() {
  stdout.writeln(
    'Usage: dart run tool/l10n_integrity_check.dart [<path-to-en-arb>] [--enforce-non-en]',
  );
  stdout.writeln('Defaults to lib/l10n/intl_en.arb if no path is provided.');
}

Set<String> _loadArbKeys(File file) {
  try {
    final content = file.readAsStringSync();
    final data = jsonDecode(content);
    if (data is! Map<String, dynamic>) return <String>{};
    return data.keys.where((key) => !key.startsWith('@')).toSet();
  } catch (e) {
    stderr.writeln('Failed to parse ARB file ${file.path}: $e');
    return <String>{};
  }
}

_ScanResult _scanDartReferences() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Unable to locate lib/ from ${Directory.current.path}');
    exit(1);
  }

  final references = <_Reference>[];
  for (final entity in libDir.listSync(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (_shouldSkip(normalized)) continue;

    final content = entity.readAsStringSync();
    references.addAll(_extractReferences(content, normalized));
  }

  return _ScanResult(references: references);
}

bool _shouldSkip(String path) {
  const skipSegments = ['/generated/', '/l10n/'];
  const skipSuffixes = ['.g.dart', '.freezed.dart', '.mocks.dart'];
  if (skipSegments.any(path.contains)) return true;
  if (skipSuffixes.any(path.endsWith)) return true;
  return false;
}

List<_Reference> _extractReferences(String content, String path) {
  final refs = <_Reference>[];

  // 1) Direct patterns: S.of(context).key, S.current.key, context.l10n.key
  for (final pattern in _referencePatterns) {
    for (final match in pattern.allMatches(content)) {
      final key = match.group(1);
      if (key == null || key.isEmpty) continue;
      refs.add(
        _Reference(
          key: key,
          path: path,
          line: _lineForOffset(content, match.start),
        ),
      );
    }
  }

  // 2) Alias patterns: final s = S.of(context); then s.key
  final aliases = _extractAliases(content);
  for (final alias in aliases) {
    final aliasPattern = RegExp(
      '\\b${RegExp.escape(alias)}\\s*\\.\\s*([A-Za-z0-9_]+)',
    );
    for (final match in aliasPattern.allMatches(content)) {
      final key = match.group(1);
      if (key == null || key.isEmpty) continue;
      refs.add(
        _Reference(
          key: key,
          path: path,
          line: _lineForOffset(content, match.start),
        ),
      );
    }
  }

  // 3) Injected/local fields of type S (common in widget composition):
  //    e.g. "final S s;" and later "s.key"
  //
  // We only enable this heuristic if we can see a field/local explicitly typed as S.
  // This keeps false positives low while supporting your pattern:
  //   class _X extends StatelessWidget { final S s; ... Text(s.someKey) }
  if (_hasTypedInjectedS(content)) {
    const injectedAlias = 's';
    final injectedPattern = RegExp(
      '\\b${RegExp.escape(injectedAlias)}\\s*\\.\\s*([A-Za-z0-9_]+)',
    );
    for (final match in injectedPattern.allMatches(content)) {
      final key = match.group(1);
      if (key == null || key.isEmpty) continue;
      refs.add(
        _Reference(
          key: key,
          path: path,
          line: _lineForOffset(content, match.start),
        ),
      );
    }
  }

  return refs;
}

Set<String> _extractAliases(String content) {
  final aliases = <String>{};

  // Supports:
  // - final s = S.of(context);
  // - final S s = S.of(context);
  // - late final s = context.l10n;
  // - var s = S.current;
  //
  // Key improvement vs previous:
  // - Allows an OPTIONAL explicit type between final/var and the name.
  final aliasPattern = RegExp(
    r'\b(?:late\s+final|final|var|const|late)\s+(?:\w+\s+)?(\w+)\s*=\s*(?:S\.of\([^;]+?\)|S\.current|context\.l10n)\s*;',
    multiLine: true,
    dotAll: true,
  );

  for (final match in aliasPattern.allMatches(content)) {
    final name = match.group(1);
    if (name != null && name.isNotEmpty) {
      aliases.add(name);
    }
  }

  return aliases;
}

bool _hasTypedInjectedS(String content) {
  // Very targeted heuristic: only treat `s.key` as localization if the file
  // explicitly declares a variable/field named `s` typed as `S`.
  //
  // Matches common forms:
  // - final S s;
  // - late final S s;
  // - final S s = ...
  // - S s;
  //
  // (We keep it strict to avoid accidentally treating random `s.foo` as l10n.)
  final typedSFieldPattern = RegExp(
    r'(^|\s)(?:late\s+)?(?:final\s+)?S\s+s(\s*[;=])',
    multiLine: true,
  );

  return typedSFieldPattern.hasMatch(content);
}

int _lineForOffset(String content, int offset) {
  var line = 1;
  for (var i = 0; i < offset && i < content.length; i++) {
    if (content.codeUnitAt(i) == 10) {
      line++;
    }
  }
  return line;
}

List<_NonEnDrift> _findNonEnExtras(
  Directory arbDir,
  String enPath,
  Set<String> canonicalKeys,
) {
  final drifts = <_NonEnDrift>[];
  for (final entity in arbDir.listSync()) {
    if (entity is! File || !entity.path.endsWith('.arb')) continue;
    if (entity.path == enPath) continue;

    final keys = _loadArbKeys(entity);
    final extras = keys.difference(canonicalKeys).toList()..sort();
    if (extras.isNotEmpty) {
      drifts.add(_NonEnDrift(path: entity.path, extraKeys: extras));
    }
  }
  return drifts;
}

class _ScanResult {
  _ScanResult({required this.references});
  final List<_Reference> references;
}

class _Reference {
  _Reference({required this.key, required this.path, required this.line});

  final String key;
  final String path;
  final int line;
}

class _NonEnDrift {
  _NonEnDrift({required this.path, required this.extraKeys});

  final String path;
  final List<String> extraKeys;
}

final _referencePatterns = <RegExp>[
  RegExp(r'S\.of\([^)]*\)\s*\.\s*([A-Za-z0-9_]+)'),
  RegExp(r'S\.current\s*\.\s*([A-Za-z0-9_]+)'),
  RegExp(r'context\.l10n\s*\.\s*([A-Za-z0-9_]+)'),
];
