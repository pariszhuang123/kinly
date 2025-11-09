import 'dart:convert';
import 'dart:io';

/// Extracts machine-readable contract blocks from docs/contracts/*_v*.md
/// Blocks are fenced as ```contracts-json ... ``` containing a single JSON object.
/// Writes an aggregated registry to docs/contracts/registry.json
Future<void> main(List<String> args) async {
  final root = Directory('docs/contracts');
  if (!root.existsSync()) {
    stderr.writeln('docs/contracts not found');
    exit(2);
  }

  final files =
      await root
            .list(recursive: false)
            .where((e) => e is File && e.path.endsWith('.md'))
            .cast<File>()
            .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final domains =
      <String, Map<String, dynamic>>{}; // domain -> {versions: {vN: {...}}}

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    // Expect names like <domain>_vN.md
    final versionRx = RegExp(r'_v(\d+)\.md$');
    final versionCap = versionRx.firstMatch(name);
    if (versionCap == null) continue; // skip non-versioned
    final version = 'v${versionCap.group(1)}';

    final content = await file.readAsString();
    final block = _extractContractsJson(content);
    if (block == null) {
      stderr.writeln('No contracts-json block in ${file.path}');
      continue;
    }
    Map<String, dynamic> json;
    try {
      json = jsonDecode(block) as Map<String, dynamic>;
    } catch (e) {
      stderr.writeln('Invalid JSON in ${file.path}: $e');
      exitCode = 1;
      continue;
    }

    final domain = (json['domain'] ?? '').toString();
    if (domain.isEmpty) {
      stderr.writeln('Missing domain in ${file.path}');
      exitCode = 1;
      continue;
    }

    final latestForDomain = domains.putIfAbsent(
      domain,
      () => {'versions': <String, Map<String, dynamic>>{}},
    );
    (latestForDomain['versions'] as Map<String, dynamic>)[version] = {
      'docs': file.path.replaceAll('\\', '/'),
      'entities': json['entities'],
      'functions': json['functions'],
      'rls': json['rls'],
    };
  }

  // Determine latest version per domain (numeric vN)
  final out = <String, dynamic>{
    // Keep deterministic for CI; avoid timestamp drift.
    'generatedAt': '',
    'domains': <String, dynamic>{},
  };

  final domainNames = domains.keys.toList()..sort();
  for (final domain in domainNames) {
    final data = domains[domain]!;
    final versions = (data['versions'] as Map<String, dynamic>);
    String? latest;
    for (final v in versions.keys) {
      if (latest == null) {
        latest = v;
      } else {
        int a = int.tryParse(v.replaceFirst('v', '')) ?? 0;
        int b = int.tryParse(latest!.replaceFirst('v', '')) ?? 0;
        if (a > b) latest = v;
      }
    }
    if (latest == null) return;
    final latestData = versions[latest];
    (out['domains'] as Map<String, dynamic>)[domain] = {
      'latest': latest,
      'docs': latestData['docs'],
      'entities': latestData['entities'],
      'functions': latestData['functions'],
      'rls': latestData['rls'],
    };
  }

  final outFile = File('docs/contracts/registry.json');
  outFile.createSync(recursive: true);
  final jsonStr = const JsonEncoder.withIndent('  ').convert(out) + '\n';
  outFile.writeAsStringSync(jsonStr);
  stdout.writeln('Wrote ${outFile.path}');
}

String? _extractContractsJson(String content) {
  final start = RegExp(r'^```contracts-json\s*$', multiLine: true);
  final end = RegExp(r'^```\s*$', multiLine: true);
  final s = start.firstMatch(content);
  if (s == null) return null;
  final after = content.substring(s.end);
  final e = end.firstMatch(after);
  if (e == null) return null;
  return after.substring(0, e.start).trim();
}
