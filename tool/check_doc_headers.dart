import 'dart:io';

const _requiredFiles = <String>[
  // Archived/migrating: only check headers for files that still exist locally.
];

const _allowedScopes = <String>{
  'backend',
  'frontend',
  'shared',
  'platform',
};

const _allowedArtifactTypes = <String>{
  'contract',
  'architecture',
  'adr',
  'guide',
  'process',
  'reference',
  'template',
};

const _requiredKeys = <String>{
  'Domain',
  'Capability',
  'Scope',
  'Artifact-Type',
  'Stability',
  'Status',
  'Version',
};

void main() {
  final errors = <String>[];

  for (final path in _requiredFiles) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final content = file.readAsStringSync();
    final header = _parseFrontMatter(content);
    if (header == null) {
      errors.add('Missing front matter: $path');
      continue;
    }
    final keys = header.keys.toSet();
    final missingKeys = _requiredKeys.difference(keys);
    if (missingKeys.isNotEmpty) {
      errors.add('Missing keys ${missingKeys.join(', ')} in $path');
    }
    final scope = header['Scope'];
    if (scope == null || !_allowedScopes.contains(scope)) {
      errors.add('Invalid Scope "$scope" in $path');
    }
    final artifactType = header['Artifact-Type'];
    if (artifactType == null ||
        !_allowedArtifactTypes.contains(artifactType)) {
      errors.add('Invalid Artifact-Type "$artifactType" in $path');
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('doc header check failed:');
    for (final err in errors) {
      stderr.writeln(' - $err');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('doc header check passed');
}

Map<String, String>? _parseFrontMatter(String content) {
  final lines = content.split('\n');
  if (lines.isEmpty || lines.first.trim() != '---') {
    return null;
  }
  final map = <String, String>{};
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trimRight();
    if (line.trim() == '---') {
      break;
    }
    final parts = line.split(':');
    if (parts.length < 2) continue;
    final key = parts.first.trim();
    final value = parts.sublist(1).join(':').trim();
    map[key] = value;
  }
  return map;
}
