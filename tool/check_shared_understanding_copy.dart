import 'dart:convert';
import 'dart:io';

/// Lint for the Shared Understanding Copy Contract (docs/contracts/shared_understanding_copy_v1.md).
/// Focuses on framing: discourages enforcement/control vocabulary in non-error/system surfaces.
Future<void> main(List<String> args) async {
  final arbPath = args.isNotEmpty ? args.first : 'lib/l10n/intl_en.arb';
  final file = File(arbPath);
  if (!file.existsSync()) {
    stderr.writeln('ARB not found at $arbPath');
    exit(1);
  }

  final Map<String, dynamic> data;
  try {
    data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  } catch (e) {
    stderr.writeln('Failed to parse ARB: $e');
    exit(1);
  }

  final violations = <_Violation>[];

  data.forEach((key, value) {
    if (key.startsWith('@')) return;
    if (value is! String) return;

    final meta = data['@$key'];
    final entry = _Entry(
      key: key,
      text: value,
      meta: meta is Map<String, dynamic> ? meta : const <String, dynamic>{},
    );

    if (entry.override) return;
    if (entry.isUgc) return;

    if (_containsDiscouragedVocabulary(entry)) {
      violations.add(
        _Violation(
          entry.key,
          'discouraged_vocabulary',
          'Contains discouraged terms for shared-understanding surfaces: ${_matchingLabels(entry).join(', ')}',
        ),
      );
    }
  });

  stdout.writeln('Violations: ${violations.length}');
  for (final v in violations.take(10)) {
    stdout.writeln('  - ${v.key}: ${v.message}');
  }

  if (violations.isNotEmpty) {
    stderr.writeln(
      'Shared understanding copy violations found (${violations.length}).',
    );
    exit(1);
  }

  stdout.writeln('Shared understanding copy checks passed.');
}

class _Entry {
  _Entry({required this.key, required this.text, required this.meta});

  final String key;
  final String text;
  final Map<String, dynamic> meta;

  String? get surface {
    final s = meta['surface'];
    return s is String ? s : null;
  }

  bool get override {
    final flag = meta['shared_understanding_override'];
    if (flag is bool) return flag;
    if (flag is String) return flag.toLowerCase() == 'true';
    return false;
  }

  bool get isUgc => meta['ugc'] == true;
}

class _Violation {
  _Violation(this.key, this.code, this.message);
  final String key;
  final String code;
  final String message;
}

final _discouragedPatterns = <String, RegExp>{
  'assign': RegExp(r'\bassign\w*', caseSensitive: false),
  'task': RegExp(r'\btask\w*\b', caseSensitive: false),
  'chore': RegExp(r'\bchore\w*\b', caseSensitive: false),
  'due': RegExp(r'\bdue\b|\boverdue\b', caseSensitive: false),
  'require': RegExp(r'\brequir\w*\b|\bmust\b', caseSensitive: false),
  'log': RegExp(r'\blog\b|\brecord\b', caseSensitive: false),
  'submit': RegExp(r'\bsubmit\w*\b', caseSensitive: false),
  'failed': RegExp(r'\bfailed\b|\bincomplete\b', caseSensitive: false),
};

final _allowedSurfaces = <String>{
  'error',
  'dialog_body',
  'dialog_title',
  'notification_title',
  'notification_body',
};

bool _containsDiscouragedVocabulary(_Entry entry) {
  if (_isAllowedSurface(entry.surface)) return false;
  return _matchingLabels(entry).isNotEmpty;
}

List<String> _matchingLabels(_Entry entry) {
  final hits = <String>[];
  _discouragedPatterns.forEach((label, pattern) {
    if (pattern.hasMatch(entry.text)) {
      hits.add(label);
    }
  });
  return hits;
}

bool _isAllowedSurface(String? surface) {
  if (surface == null) return false;
  return _allowedSurfaces.contains(surface);
}
