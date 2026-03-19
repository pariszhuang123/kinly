import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Copy lint aligned with docs/contracts/copy_taste_v1_1.md.
/// Checks EN ARB for surface limits, readability, placeholders, plurals,
/// banned words, notification punctuation, and reports warnings (missing surface).
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

  final reports = <_Report>[];
  final warnings = <_Report>[];

  data.forEach((key, value) {
    if (key.startsWith('@')) return;
    if (value is! String) return;

    final meta = data['@$key'];
    final entry = _Entry(
      key: key,
      text: value,
      meta: meta is Map<String, dynamic> ? meta : const <String, dynamic>{},
    );

    final surface = entry.surface;
    final textForLength = _stripPlaceholders(entry.text);

    // Surface presence warning.
    if (surface == null) {
      warnings.add(
        _Report(
          key,
          'missing_surface_tag',
          'No @surface metadata; using body defaults.',
        ),
      );
    }

    // Length checks (blocking).
    final limit = _lengthLimit(surface);
    if (limit != null && textForLength.length > _applyTolerance(limit)) {
      reports.add(
        _Report(
          key,
          'length_limit',
          'Length ${textForLength.length} exceeds limit $limit (+5% tolerance). Surface=$surface',
        ),
      );
    }

    // Sentence length.
    final sentences = _splitSentences(entry.text);
    for (final sentence in sentences) {
      final words = _wordCount(sentence);
      if (words > 18) {
        reports.add(
          _Report(
            key,
            'sentence_too_long',
            'Sentence has $words words (limit 18).',
          ),
        );
        break;
      }
    }

    // Readability.
    final bodyLength = _wordCount(textForLength);
    if (textForLength.trim().length > 50 && bodyLength > 0) {
      final grade = _fleschKincaid(textForLength);
      if (grade > 7) {
        reports.add(
          _Report(
            key,
            'readability',
            'Flesch-Kincaid grade ${grade.toStringAsFixed(2)} exceeds 7.',
          ),
        );
      }
    }

    // Placeholders.
    final placeholderNames = _extractPlaceholders(entry.text);
    if (placeholderNames.isNotEmpty) {
      if (meta is! Map<String, dynamic> || meta.isEmpty) {
        reports.add(
          _Report(
            key,
            'missing_metadata',
            'Placeholders present but @metadata missing.',
          ),
        );
      }
      final placeholdersMeta =
          (meta is Map<String, dynamic>)
              ? (meta['placeholders'] as Map<String, dynamic>? ??
                  const <String, dynamic>{})
              : const <String, dynamic>{};
      for (final name in placeholderNames) {
        final m = placeholdersMeta[name];
        if (m is! Map<String, dynamic>) {
          reports.add(
            _Report(
              key,
              'placeholder_missing',
              'Placeholder {$name} missing metadata.',
            ),
          );
          continue;
        }
        if (!m.containsKey('type')) {
          reports.add(
            _Report(
              key,
              'placeholder_type_missing',
              'Placeholder {$name} missing type.',
            ),
          );
        }
        if (!m.containsKey('example')) {
          reports.add(
            _Report(
              key,
              'placeholder_example_missing',
              'Placeholder {$name} missing example.',
            ),
          );
        }
      }
    }

    // ICU plural.
    final hasCountPlaceholder = placeholderNames.contains('count');
    final usesPluralSyntax = RegExp(
      r'\{count\s*,\s*plural',
      caseSensitive: false,
    ).hasMatch(entry.text);
    if (hasCountPlaceholder && !usesPluralSyntax) {
      reports.add(
        _Report(
          key,
          'missing_plural',
          'Contains {count} but no ICU plural syntax.',
        ),
      );
    }

    // Banned words (skip if marked UGC).
    final isUgc = (meta is Map<String, dynamic>) && meta['ugc'] == true;
    if (!isUgc) {
      final banned = _findBanned(entry.text);
      if (banned.isNotEmpty) {
        reports.add(
          _Report(
            key,
            'banned_word',
            'Contains banned term(s): ${banned.join(', ')}',
          ),
        );
      }
    }

    // Notifications punctuation/caps.
    if (surface == 'notification_title' || surface == 'notification_body') {
      if (_isAllCaps(entry.text)) {
        reports.add(
          _Report(key, 'notification_caps', 'Notification text is all caps.'),
        );
      }
      if (_excessPunctuation(entry.text)) {
        reports.add(
          _Report(
            key,
            'notification_punctuation',
            'Notification has excessive punctuation.',
          ),
        );
      }
    }
  });

  void printSummary(String label, List<_Report> items) {
    stdout.writeln('$label: ${items.length}');
    final grouped = <String, List<_Report>>{};
    for (final r in items) {
      grouped.putIfAbsent(r.code, () => []).add(r);
    }
    for (final entry in grouped.entries) {
      stdout.writeln('  - ${entry.key}: ${entry.value.length}');
      for (final sample in entry.value.take(3)) {
        stdout.writeln('      ${sample.key}: ${sample.message}');
      }
    }
  }

  printSummary('Warnings (non-blocking)', warnings);
  printSummary('Violations (blocking)', reports);

  if (reports.isNotEmpty) {
    stderr.writeln('Copy contract violations found (${reports.length}).');
    exit(1);
  }

  stdout.writeln('Copy contract checks passed.');
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
}

class _Report {
  _Report(this.key, this.code, this.message);
  final String key;
  final String code;
  final String message;
}

int? _lengthLimit(String? surface) {
  const limits = <String, int>{
    'button': 22,
    'title': 28,
    'title_hero': 40, // if caller sets explicit variant
    'subtitle': 110,
    'snackbar': 70,
    'dialog_title': 40,
    'dialog_body': 200, // enforce via sentence length; generous char cap
    'empty_title': 40,
    'empty_body': 200,
    'error': 200,
    'notification_title': 40,
    'notification_body': 90,
    'email_subject': 60,
    'email_body': 400,
    'paywall_title': 28,
    'paywall_subtitle': 110,
    'paywall_bullet': 90,
    'onboarding_hint': 110,
    'tooltip': 90,
    'success_message': 90,
    'empty_hint': 110,
  };
  if (surface == null) return null;
  return limits[surface];
}

int _applyTolerance(int limit) {
  return (limit * 1.05).ceil();
}

String _stripPlaceholders(String text) {
  return text.replaceAll(RegExp(r'\{[^}]+\}'), '').trim();
}

List<String> _extractPlaceholders(String text) {
  final placeholders = <String>{};
  _collectPlaceholders(text, placeholders);
  return placeholders.toList();
}

void _collectPlaceholders(String text, Set<String> placeholders) {
  var index = 0;
  while (index < text.length) {
    final start = text.indexOf('{', index);
    if (start == -1) return;
    final end = _findMatchingBrace(text, start);
    if (end == -1) return;

    final content = text.substring(start + 1, end);
    final firstComma = _findTopLevelComma(content);
    if (firstComma == -1) {
      final match = RegExp(r'^\s*(\w+)\s*$').firstMatch(content);
      if (match != null) {
        placeholders.add(match.group(1)!);
      }
    } else {
      final nameMatch = RegExp(r'^\s*(\w+)').firstMatch(content);
      if (nameMatch != null) {
        placeholders.add(nameMatch.group(1)!);
      }

      final secondComma = _findTopLevelComma(content, firstComma + 1);
      if (secondComma != -1) {
        _collectIcuOptionPlaceholders(
          content.substring(secondComma + 1),
          placeholders,
        );
      }
    }

    index = end + 1;
  }
}

void _collectIcuOptionPlaceholders(String text, Set<String> placeholders) {
  var index = 0;
  while (index < text.length) {
    while (index < text.length && text[index].trim().isEmpty) {
      index++;
    }
    while (index < text.length && text[index] != '{') {
      index++;
    }
    if (index >= text.length) return;

    final end = _findMatchingBrace(text, index);
    if (end == -1) return;
    _collectPlaceholders(text.substring(index + 1, end), placeholders);
    index = end + 1;
  }
}

int _findMatchingBrace(String text, int start) {
  var depth = 0;
  for (var i = start; i < text.length; i++) {
    if (text[i] == '{') depth++;
    if (text[i] == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

int _findTopLevelComma(String text, [int start = 0]) {
  var depth = 0;
  for (var i = start; i < text.length; i++) {
    if (text[i] == '{') depth++;
    if (text[i] == '}') depth--;
    if (text[i] == ',' && depth == 0) return i;
  }
  return -1;
}

List<String> _splitSentences(String text) {
  return text
      .split(RegExp(r'[.!?]+'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

int _wordCount(String text) {
  final cleaned = text.replaceAll(RegExp(r'\{[^}]+\}'), '');
  if (cleaned.trim().isEmpty) return 0;
  return cleaned.trim().split(RegExp(r'\s+')).length;
}

double _fleschKincaid(String text) {
  final sentences = max(1, _splitSentences(text).length);
  final words = max(1, _wordCount(text));
  final syllables = max(1, _countSyllables(text));
  return 0.39 * (words / sentences) + 11.8 * (syllables / words) - 15.59;
}

int _countSyllables(String text) {
  final vowels = RegExp(r'[aeiouyAEIOUY]+');
  final words = text
      .replaceAll(RegExp(r'[^A-Za-z\s]'), '')
      .split(RegExp(r'\s+'));
  var syllables = 0;
  for (final word in words) {
    if (word.isEmpty) continue;
    final matches = vowels.allMatches(word);
    var count = matches.length;
    if (word.endsWith('e') && count > 1) count--;
    syllables += max(1, count);
  }
  return max(1, syllables);
}

final Map<String, RegExp> _bannedPatterns = {
  'owe': RegExp(r'\bowe\b', caseSensitive: false),
  'debt': RegExp(r'\bdebt\b', caseSensitive: false),
  'failed': RegExp(r'\bfailed\b', caseSensitive: false),
  'broke': RegExp(r'\bbroke\b', caseSensitive: false),
  'streak': RegExp(r'\bstreak\b', caseSensitive: false),
  'urgent': RegExp(r'\burgent\b', caseSensitive: false),
  'immediately': RegExp(r'immediately', caseSensitive: false),
  'last chance': RegExp(r'last chance', caseSensitive: false),
  'deadline': RegExp(r'deadline', caseSensitive: false),
  'warning': RegExp(r'\bwarning\b', caseSensitive: false),
  'mistake': RegExp(r'\bmistake\b', caseSensitive: false),
  'fault': RegExp(r'\bfault\b', caseSensitive: false),
  'penalty': RegExp(r'\bpenalty\b', caseSensitive: false),
  'must': RegExp(r'\bmust\b', caseSensitive: false),
  'should': RegExp(r'\bshould\b', caseSensitive: false),
  'cannot': RegExp(r'\bcannot\b', caseSensitive: false),
  "can't": RegExp(r"\bcan't\b", caseSensitive: false),
  'late': RegExp(r'\blate\b', caseSensitive: false),
  'overdue': RegExp(r'overdue', caseSensitive: false),
  'fix': RegExp(r'\bfix\b', caseSensitive: false),
  'correct': RegExp(r'\bcorrect\b', caseSensitive: false),
  'punish': RegExp(r'\bpunish\b', caseSensitive: false),
  'require': RegExp(r'\brequire\b', caseSensitive: false),
  'you forgot': RegExp(r'you forgot', caseSensitive: false),
};

List<String> _findBanned(String text) {
  final hits = <String>{};
  _bannedPatterns.forEach((label, pattern) {
    if (pattern.hasMatch(text)) {
      hits.add(label);
    }
  });
  return hits.toList();
}

bool _isAllCaps(String text) {
  final letters = RegExp(r'[A-Z]');
  final hasLower = RegExp(r'[a-z]').hasMatch(text);
  final hasUpper = letters.hasMatch(text);
  return hasUpper && !hasLower;
}

bool _excessPunctuation(String text) {
  final exclamations = RegExp(r'!').allMatches(text).length;
  final questions = RegExp(r'\?').allMatches(text).length;
  return exclamations > 1 || questions > 1;
}
