import 'dart:io';

const _requiredFiles = <String>[
  'db/README.md',
  'docs/adr/ADR-0001-mvp-home-scope.md',
  'docs/adr/ADR-0001-user-auth-and-account-lifecycle.md',
  'docs/adr/ADR-0002-invites-permanent-codes.md',
  'docs/adr/ADR-0003-expenses-rpc-only-access.md',
  'docs/contracts/homes_v2.md',
  'docs/contracts/home_dynamics_v1.md',
  'docs/contracts/house_vibe_canonical_preference_schema_v1.md',
  'docs/contracts/house_vibe_compute_rpc_contract_v1.md',
  'docs/contracts/house_vibe_label_registry_contract_v1.md',
  'docs/contracts/house_vibe_mapping_contract_v1.md',
  'docs/contracts/house_vibe_mapping_effects_v1.md',
  'docs/contracts/kinly_control_color_tokens_v1.md',
  'docs/contracts/kinly_design_system_v1.md',
  'docs/contracts/paywall_v1.md',
  'docs/contracts/share_recurring_v1.md',
  'docs/contracts/users_v1.md',
  'docs/contracts/testing_v1.md',
  'docs/engineering/architecture_guardrails_v1_1.md',
  'docs/engineering/complexity_budget_v1.md',
  'docs/ui/core_ui_primitives.md',
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
      errors.add('Missing file: $path');
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
