import 'dart:io';

class ReportLanguageViolation {
  const ReportLanguageViolation(this.path, this.line, this.term, this.message);
  final String path;
  final int line;
  final String term;
  final String message;
}

List<ReportLanguageViolation> checkPreferenceReportLanguage({
  String docPath = 'docs/contracts/preference_reports_v1.md',
}) {
  final file = File(docPath);
  if (!file.existsSync()) {
    return [
      ReportLanguageViolation(
        docPath,
        0,
        'missing_file',
        'Report contract not found at $docPath',
      ),
    ];
  }

  final content = file.readAsStringSync();
  final block = _extractBlock(content, 'preference-report-copy');
  if (block == null) {
    return [
      ReportLanguageViolation(
        docPath,
        0,
        'missing_block',
        'Missing preference-report-copy block in $docPath',
      ),
    ];
  }

  final violations = <ReportLanguageViolation>[];
  final lines = block.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    for (final entry in _bannedPatterns.entries) {
      if (entry.value.hasMatch(line)) {
        violations.add(
          ReportLanguageViolation(
            docPath,
            i + 1,
            entry.key,
            'Report copy must not include enforcement language.',
          ),
        );
      }
    }
  }

  return violations;
}

void main(List<String> args) {
  final docPath =
      _readArg(args, '--doc-path=') ??
      'docs/contracts/preference_reports_v1.md';
  final violations = checkPreferenceReportLanguage(docPath: docPath);

  if (violations.isEmpty) {
    stdout.writeln('Preference report language checks passed.');
    return;
  }

  stdout.writeln(
    'Preference report language checks failed (${violations.length}):',
  );
  for (final v in violations) {
    stdout.writeln(' - ${v.path}:${v.line} ${v.term} ${v.message}');
  }
  exitCode = 1;
}

String? _extractBlock(String content, String fence) {
  final start = RegExp('^```$fence\\s*\$', multiLine: true);
  final end = RegExp(r'^```\s*$', multiLine: true);
  final s = start.firstMatch(content);
  if (s == null) return null;
  final after = content.substring(s.end);
  final e = end.firstMatch(after);
  if (e == null) return null;
  return after.substring(0, e.start).trimRight();
}

String? _readArg(List<String> args, String prefix) {
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      return arg.substring(prefix.length);
    }
  }
  return null;
}

final Map<String, RegExp> _bannedPatterns = {
  'must': RegExp(r'\bmust\b', caseSensitive: false),
  'required': RegExp(r'\brequired\b', caseSensitive: false),
  'require': RegExp(r'\brequire\b', caseSensitive: false),
  'should': RegExp(r'\bshould\b', caseSensitive: false),
  'have_to': RegExp(r'\bhave to\b', caseSensitive: false),
  'need_to': RegExp(r'\bneed to\b', caseSensitive: false),
  'not_allowed': RegExp(r'not allowed', caseSensitive: false),
  'forbidden': RegExp(r'\bforbidden\b', caseSensitive: false),
  'prohibited': RegExp(r'\bprohibited\b', caseSensitive: false),
  'mandatory': RegExp(r'\bmandatory\b', caseSensitive: false),
};
