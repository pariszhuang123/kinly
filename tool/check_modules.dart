import 'dart:io';

import 'package:yaml/yaml.dart';

/// Lightweight guardrail checker for modules.yml.
/// - Validates manifest shape and cross-references.
/// - Ensures unique module/table/RPC ownership.
/// - Aligns manifest with lib/features directories.
/// Fails with non-zero exit if violations are found.
Future<void> main(List<String> args) async {
  final manifestFile = File('modules.yml');
  if (!manifestFile.existsSync()) {
    stderr.writeln('modules.yml not found at repo root.');
    exit(1);
  }

  final errors = <String>[];
  final warnings = <String>[];

  late final List<_Module> modules;
  try {
    modules = _loadModules(manifestFile.readAsStringSync(), errors);
  } catch (e) {
    stderr.writeln('Failed to parse modules.yml: $e');
    exit(1);
  }

  if (modules.isEmpty) {
    errors.add('No modules defined in modules.yml');
  }

  _checkDuplicates(modules, errors);
  _checkDependencies(modules, errors);
  _checkTables(modules, errors);
  _checkRpcs(modules, errors);
  _checkFeatureDirs(modules, errors, warnings);
  _checkKillSwitchFlags(modules, warnings);

  if (warnings.isNotEmpty) {
    stdout.writeln('Warnings:');
    for (final warning in warnings) {
      stdout.writeln(' - $warning');
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Errors:');
    for (final error in errors) {
      stderr.writeln(' - $error');
    }
    exit(1);
  }

  stdout.writeln('modules.yml checks passed.');
}

List<_Module> _loadModules(String contents, List<String> errors) {
  final doc = loadYaml(contents);
  if (doc is! YamlMap) {
    throw FormatException('modules.yml root must be a map');
  }
  final modulesNode = doc['modules'];
  if (modulesNode is! YamlList) {
    throw FormatException('modules.yml must contain a modules list');
  }

  return modulesNode.map<_Module>((node) {
    if (node is! YamlMap) {
      throw FormatException('each module entry must be a map');
    }
    final name = node['name'];
    final status = node['status'];
    final killable = node['killable'];
    final dependsOn = _stringList(node['depends_on']);
    final allowedImportsFrom = _stringList(node['allowed_imports_from']);
    final tablesOwned = _stringList(node['data']?['tables_owned']);
    final ownerRpcs = _stringList(node['rpcs']?['owner']);
    final orchestrationRpcs = _stringList(node['rpcs']?['orchestration']);
    final killSwitchFlag = node['kill_switch_flag'];

    if (name is! String) {
      errors.add('module entry missing valid name');
    }
    if (status is! String) {
      errors.add('module "$name" missing status');
    }
    if (killable is! bool) {
      errors.add('module "$name" missing killable (bool)');
    }

    return _Module(
      name: name is String ? name : '',
      status: status is String ? status : '',
      killable: killable is bool ? killable : false,
      killSwitchFlag: killSwitchFlag is String ? killSwitchFlag : null,
      dependsOn: dependsOn,
      allowedImportsFrom: allowedImportsFrom,
      tablesOwned: tablesOwned,
      ownerRpcs: ownerRpcs,
      orchestrationRpcs: orchestrationRpcs,
    );
  }).toList();
}

List<String> _stringList(dynamic node) {
  if (node is YamlList) {
    return node.whereType().map((e) => e.toString()).toList();
  }
  if (node is List) {
    return node.whereType<String>().toList();
  }
  return [];
}

void _checkDuplicates(List<_Module> modules, List<String> errors) {
  final names = <String>{};
  for (final module in modules) {
    if (!names.add(module.name)) {
      errors.add('duplicate module name "${module.name}"');
    }
  }
}

void _checkDependencies(List<_Module> modules, List<String> errors) {
  final names = modules.map((m) => m.name).toSet();
  for (final module in modules) {
    for (final dep in module.dependsOn) {
      if (!names.contains(dep)) {
        errors.add('module "${module.name}" depends_on unknown module "$dep"');
      }
    }
    for (final allowed in module.allowedImportsFrom) {
      if (allowed == '*') continue;
      if (!names.contains(allowed)) {
        errors.add(
          'module "${module.name}" allowed_imports_from references unknown module "$allowed"',
        );
      }
    }
  }
}

void _checkTables(List<_Module> modules, List<String> errors) {
  final tableOwners = <String, String>{};
  for (final module in modules) {
    for (final table in module.tablesOwned) {
      final existing = tableOwners[table];
      if (existing != null && existing != module.name) {
        errors.add(
          'table "$table" owned by both "$existing" and "${module.name}"',
        );
      } else {
        tableOwners[table] = module.name;
      }
    }
  }
}

void _checkRpcs(List<_Module> modules, List<String> errors) {
  final rpcOwners = <String, String>{};
  for (final module in modules) {
    for (final rpc in [...module.ownerRpcs, ...module.orchestrationRpcs]) {
      final existing = rpcOwners[rpc];
      if (existing != null && existing != module.name) {
        errors.add('RPC "$rpc" owned by both "$existing" and "${module.name}"');
      } else {
        rpcOwners[rpc] = module.name;
      }
    }
  }
}

void _checkFeatureDirs(
  List<_Module> modules,
  List<String> errors,
  List<String> warnings,
) {
  final featureDir = Directory('lib/features');
  if (!featureDir.existsSync()) {
    warnings.add('lib/features not found; skipping feature directory checks.');
    return;
  }

  final featureFolders = featureDir
      .listSync()
      .whereType<Directory>()
      .map((d) => d.uri.pathSegments[d.uri.pathSegments.length - 2])
      .toSet();

  final manifestNames = modules.map((m) => m.name).toSet();

  for (final folder in featureFolders) {
    if (!manifestNames.contains(folder)) {
      errors.add('feature folder "lib/features/$folder" missing in modules.yml');
    }
  }

  for (final module in modules) {
    final hasFeatureDir = featureFolders.contains(module.name);
    final hasLibRoot = Directory('lib/${module.name}').existsSync();
    final hasFoundationSurface =
        Directory('lib/foundation/surfaces/${module.name}').existsSync();
    if (!hasFeatureDir && !hasLibRoot && !hasFoundationSurface) {
      warnings.add(
        'module "${module.name}" has no matching folder under lib/features/, lib/${module.name}/, or lib/foundation/surfaces/${module.name}/',
      );
    }
  }
}

void _checkKillSwitchFlags(List<_Module> modules, List<String> warnings) {
  for (final module in modules) {
    if (module.killable && module.killSwitchFlag == null) {
      warnings.add(
        'module "${module.name}" is killable but kill_switch_flag is not set',
      );
    }
  }
}

class _Module {
  _Module({
    required this.name,
    required this.status,
    required this.killable,
    required this.killSwitchFlag,
    required this.dependsOn,
    required this.allowedImportsFrom,
    required this.tablesOwned,
    required this.ownerRpcs,
    required this.orchestrationRpcs,
  });

  final String name;
  final String status;
  final bool killable;
  final String? killSwitchFlag;
  final List<String> dependsOn;
  final List<String> allowedImportsFrom;
  final List<String> tablesOwned;
  final List<String> ownerRpcs;
  final List<String> orchestrationRpcs;
}
