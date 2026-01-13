import 'dart:io';

import 'package:path/path.dart' as p;

void main() {
  final repoRoot = Directory.current.path;
  final uiDir = Directory(p.join(repoRoot, 'lib', 'core', 'ui'));
  final docPath = p.join(repoRoot, 'docs', 'ui', 'core_ui_primitives.md');
  final allowlistPath = p.join(
    repoRoot,
    'tool',
    'core_ui_primitives_allowlist.txt',
  );

  if (!uiDir.existsSync()) {
    stderr.writeln('lib/core/ui not found; skipping');
    return;
  }
  if (!File(docPath).existsSync()) {
    stderr.writeln('docs/ui/core_ui_primitives.md missing; skipping');
    return;
  }

  final docContent = File(docPath).readAsStringSync().toLowerCase();
  final allowlist = _readAllowlist(allowlistPath);
  final primitives = _collectPrimitives(uiDir);

  final documented =
      primitives.where((relativePath) {
        final name = p.basenameWithoutExtension(relativePath).toLowerCase();
        return docContent.contains(name);
      }).toSet();

  final missing = primitives.difference(documented).difference(allowlist);
  if (missing.isEmpty) {
    stdout.writeln('core_ui_primitives doc coverage OK');
    return;
  }

  stderr.writeln(
    'Found core UI primitives missing from docs/ui/core_ui_primitives.md:',
  );
  for (final path in missing) {
    stderr.writeln(' - $path');
  }
  stderr.writeln(
    'Document them in docs/ui/core_ui_primitives.md or add a temporary entry '
    'to tool/core_ui_primitives_allowlist.txt with rationale/expiry.',
  );
  exitCode = 1;
}

Set<String> _collectPrimitives(Directory uiDir) {
  final primitives = <String>{};
  for (final entity in uiDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final relative = p
        .relative(entity.path, from: uiDir.path)
        .replaceAll('\\', '/');
    if (_isIgnored(relative)) continue;
    primitives.add(relative);
  }
  return primitives;
}

bool _isIgnored(String relativePath) {
  // Ignore tests and generated files.
  final lower = relativePath.toLowerCase();
  if (lower.endsWith('_test.dart')) return true;
  if (lower.endsWith('.g.dart')) return true;
  return false;
}

Set<String> _readAllowlist(String allowlistPath) {
  final file = File(allowlistPath);
  if (!file.existsSync()) return <String>{};
  return file
      .readAsLinesSync()
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty && !line.startsWith('#'))
      .map((line) => line.replaceAll('\\', '/'))
      .toSet();
}
