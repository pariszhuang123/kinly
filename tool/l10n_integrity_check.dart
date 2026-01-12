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
///   - context.strings.key              // optional (common extension naming)
///   - scope.strings.key                // SurfaceScope/registry access
///   - scope.l10n.key                    // SurfaceScope/registry access
///   - Aliases such as:
///       final s = S.of(context);
///       final S s = S.of(context);
///       final s = context.l10n;
///       final strings = context.strings;
///   - Injected localization instances:
///       class Foo { final S strings; ... }  // supports ANY variable name typed as S
///       class Foo { final S s; ... }        // still supported
///   - Function/method parameters typed as S:
///       String foo(S s, ...) { ... }
///       String foo({required S s, S? t}) { ... }
///
/// How “unused keys” can be false positives:
/// - The checker is regex-based; if your project uses a different accessor name
///   or injects S with a different variable name, the scanner must recognize it.
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

  // 1) Direct patterns: S.of(context).key, S.current.key, context.l10n.key, context.strings.key
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

  // 2) Alias patterns: final strings = context.l10n; then strings.key
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

  // 3) Injected/local fields/params of type S (widget composition + helper functions):
  //    Detect ANY variable/field/parameter name typed as S (or S?).
  final injectedNames = _findTypedSNames(content);
  for (final name in injectedNames) {
    final injectedPattern = RegExp(
      '\\b${RegExp.escape(name)}\\s*\\.\\s*([A-Za-z0-9_]+)',
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

  // 4) Lambda references for String Function(S) (e.g. preference scenarios).
  refs.addAll(_extractLambdaSReferences(content, path));

  return refs;
}

Set<String> _extractAliases(String content) {
  final aliases = <String>{};

  // Supports:
  // - final s = S.of(context);
  // - final S s = S.of(context);
  // - late final s = context.l10n;
  // - var s = S.current;
  // - final strings = context.strings;
  // - final s = scope.strings;
  //
  // Key improvement:
  // - Allows an OPTIONAL explicit type between final/var and the name.
  // - Allows any "<identifier>.l10n" or "<identifier>.strings" source.
  final aliasPattern = RegExp(
    r'\b(?:late\s+final|final|var|const|late)\s+(?:\w+\s+)?(\w+)\s*=\s*(?:S\.of\([^;]+?\)|S\.current|[A-Za-z_]\w*\.(?:l10n|strings))\s*;',
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

Set<String> _findTypedSNames(String content) {
  // Detect variable/field/parameter names typed as `S` or `S?`.
  //
  // Matches common forms:
  // - final S s;
  // - late final S strings;
  // - S strings;
  // - final S strings = ...
  // - S strings = ...
  // - final S titleStrings, subtitleStrings;  (comma-separated declarations)
  // - foo(S s, ...)
  // - foo({required S s, S? t})
  //
  // We keep this fairly strict (type must be exactly `S` or `S?`) to avoid treating random
  // `x.key` accesses as l10n.
  final names = <String>{};

  // 1) Fields/locals: single-name declarations.
  final singlePattern = RegExp(
    r'(^|\s)(?:late\s+)?(?:final\s+)?S\??\s+([A-Za-z_]\w*)\s*(?=[;=,\)\n])',
    multiLine: true,
  );
  for (final m in singlePattern.allMatches(content)) {
    final name = m.group(2);
    if (name != null && name.isNotEmpty) names.add(name);
  }

  // 2) Fields/locals: comma-separated declarations: "final S a, b, c;"
  final multiPattern = RegExp(
    r'(^|\s)(?:late\s+)?(?:final\s+)?S\??\s+([A-Za-z_]\w*(?:\s*,\s*[A-Za-z_]\w*)+)\s*(?=[;=\)\n])',
    multiLine: true,
  );
  for (final m in multiPattern.allMatches(content)) {
    final group = m.group(2);
    if (group == null || group.isEmpty) continue;
    for (final part in group.split(',')) {
      final name = part.trim();
      if (name.isNotEmpty) names.add(name);
    }
  }

  // 3) Function/method parameters typed as S/S? (positional + named).
  //
  // Examples matched:
  // - foo(S s, int x)
  // - foo({required S s, int x})
  // - foo({S? s})
  // - foo(int x, S s)
  //
  // We only capture the identifier after S/S? and optional `required`.
  final paramPattern = RegExp(
    r'[\(\{,]\s*(?:required\s+)?S\??\s+([A-Za-z_]\w*)\b',
    multiLine: true,
  );
  for (final m in paramPattern.allMatches(content)) {
    final name = m.group(1);
    if (name != null && name.isNotEmpty) names.add(name);
  }

  return names;
}

List<_Reference> _extractLambdaSReferences(String content, String path) {
  final refs = <_Reference>[];
  if (!content.contains('String Function(S)') &&
      !content.contains('PreferenceScenarioDefinition')) {
    return refs;
  }

  final lambdaPattern = RegExp(
    r'\(\s*([A-Za-z_]\w*)\s*\)\s*=>\s*\1\s*\.\s*([A-Za-z0-9_]+)',
  );
  for (final match in lambdaPattern.allMatches(content)) {
    final key = match.group(2);
    if (key == null || key.isEmpty) continue;
    refs.add(
      _Reference(
        key: key,
        path: path,
        line: _lineForOffset(content, match.start),
      ),
    );
  }
  return refs;
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
  RegExp(r'context\.strings\s*\.\s*([A-Za-z0-9_]+)'),
  RegExp(r'\b\w+\.l10n\s*\.\s*([A-Za-z0-9_]+)'),
  RegExp(r'\b\w+\.strings\s*\.\s*([A-Za-z0-9_]+)'),
];
