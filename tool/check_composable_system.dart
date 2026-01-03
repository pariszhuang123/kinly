import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

final _screenPattern = RegExp(r'^lib/features/[^/]+/ui/.*_screen\.dart$');
final _surfacePattern = RegExp(r'^lib/features/[^/]+/ui/.*_surface\.dart$');
final _foundationSurfacePrefix = 'lib/foundation/surfaces/';
final _contractsPrefix = 'lib/contracts/';
final _forbiddenContractsImports = <RegExp>[
  RegExp(r"^package:flutter/"),
  RegExp(r"^package:intl/"),
];
final _allowedCorePrefixes = <String>[
  'lib/core/ui/',
  'lib/core/theme/',
  'lib/core/di/',
  'lib/core/logging/',
  'lib/core/time/',
  'lib/core/config/',
  'lib/core/platform/',
  'lib/core/notifications/',
];
final _portNamePattern = RegExp(r'(Port|Repository|Gateway)$');
final _dtoSuffixes = <String>[
  'Dto',
  'Summary',
  'Entry',
  'Payload',
  'View',
  'Snapshot',
];

class Violation {
  Violation({
    required this.ruleId,
    required this.path,
    required this.line,
    required this.message,
    this.importPath,
    this.sourceFeature,
    this.targetFeature,
  });

  final String ruleId;
  final String path;
  final int line;
  final String message;
  final String? importPath;
  final String? sourceFeature;
  final String? targetFeature;

  String formatLine() {
    final importInfo = importPath == null ? '' : ' import="$importPath"';
    return '$path:$line [$ruleId] $message$importInfo';
  }
}

void main(List<String> args) {
  final strict = args.contains('--strict');
  final contractsStrict = args.contains('--contracts-strict');
  final placementStrict = args.contains('--placement-strict');
  final violations = <Violation>[];
  var hasContractViolations = false;
  var hasPlacementViolations = false;
  var hasFoundationViolations = false;

  final files = _dartFilesUnder('lib').toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final foundationViolations = _checkFile(file, violations);
    hasFoundationViolations = hasFoundationViolations || foundationViolations;
    final contractViolations = _checkContractsFile(file, violations);
    hasContractViolations = hasContractViolations || contractViolations;
    final placementViolations = _checkPlacementFile(file, violations);
    hasPlacementViolations = hasPlacementViolations || placementViolations;
  }

  if (violations.isEmpty) {
    stdout.writeln('Composable system check passed');
    return;
  }

  final strictMode = strict || contractsStrict || placementStrict;
  if (strictMode) {
    _printStrictSummary(violations);
  } else {
    stderr.writeln('Composable system warnings (${violations.length}):');
    for (final v in violations) {
      stderr.writeln(' - ${v.formatLine()}');
    }
  }

  if (strict ||
      (contractsStrict && hasContractViolations) ||
      (placementStrict && (hasPlacementViolations || hasFoundationViolations))) {
    exitCode = 1;
  }
}

Iterable<File> _dartFilesUnder(String root) sync* {
  final rootDir = Directory(root);
  if (!rootDir.existsSync()) return;
  for (final entry in rootDir.listSync(recursive: true, followLinks: false)) {
    if (entry is File && entry.path.endsWith('.dart')) {
      yield entry;
    }
  }
}

bool _isSurfaceFile(String path) {
  return _screenPattern.hasMatch(path) || _surfacePattern.hasMatch(path);
}

bool _isFoundationSurfaceFile(String path) {
  return path.replaceAll('\\', '/').startsWith(_foundationSurfacePrefix);
}

bool _isContractsFile(String path) {
  return path.replaceAll('\\', '/').startsWith(_contractsPrefix);
}

String? _featureForPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  final featureIndex = parts.indexOf('features');
  if (featureIndex == -1 || featureIndex + 1 >= parts.length) return null;
  return parts[featureIndex + 1];
}

bool _isGenerated(File file) {
  final path = file.path.replaceAll('\\', '/');
  return path.contains('/generated/') ||
      path.endsWith('.g.dart') ||
      path.endsWith('.freezed.dart');
}

bool _checkFile(File file, List<Violation> violations) {
  if (_isGenerated(file)) return false;
  final path = file.path.replaceAll('\\', '/');
  var hasViolations = false;

  if (_surfacePattern.hasMatch(path) && path.startsWith('lib/features/')) {
    violations.add(
      Violation(
        ruleId: 'surface-path-placement',
        path: path,
        line: 1,
        message: 'surface files must live under lib/foundation/surfaces/**',
      ),
    );
    hasViolations = true;
  }

  if (_isFoundationSurfaceFile(path)) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('import')) continue;
      final importPath = _extractImportPath(line);
      if (importPath == null) continue;

      final resolvedPath = _resolveToLibPath(file, importPath);
      if (resolvedPath != null &&
          resolvedPath.startsWith('lib/features/')) {
        violations.add(
          Violation(
            ruleId: 'foundation-imports-feature',
            path: path,
            line: i + 1,
            message: 'foundation surfaces must not import features',
            importPath: importPath,
          ),
        );
        hasViolations = true;
      }

      if (resolvedPath != null &&
          resolvedPath.startsWith('lib/core/') &&
          !_isAllowedCoreImport(resolvedPath)) {
        violations.add(
          Violation(
            ruleId: 'foundation-imports-core-nonfoundation',
            path: path,
            line: i + 1,
            message:
                'foundation surfaces must not import core outside foundation',
            importPath: importPath,
          ),
        );
        hasViolations = true;
      }
    }
  }

  if (path.startsWith('lib/features/')) {
    final feature = _featureForPath(path);
    if (feature != null) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('import')) continue;
        final importPath = _extractImportPath(line);
        if (importPath == null) continue;

        final targetFeature = _targetFeatureForImport(
          file: file,
          importPath: importPath,
        );
        if (targetFeature != null && targetFeature != feature) {
          violations.add(
            Violation(
              ruleId: 'feature-cross-import',
              path: path,
              line: i + 1,
              message: 'features must not import other features',
              importPath: importPath,
              sourceFeature: feature,
              targetFeature: targetFeature,
            ),
          );
          hasViolations = true;
        }

        final resolvedPath = _resolveToLibPath(file, importPath);
        if (resolvedPath != null &&
            resolvedPath.startsWith(_foundationSurfacePrefix)) {
          violations.add(
            Violation(
              ruleId: 'feature-imports-foundation',
              path: path,
              line: i + 1,
              message: 'features must not import foundation surfaces',
              importPath: importPath,
            ),
          );
          hasViolations = true;
        }
      }
    }
  }

  if (!_isSurfaceFile(path)) return hasViolations;

  final feature = _featureForPath(path);
  if (feature == null) return hasViolations;

  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (!line.startsWith('import')) continue;
    final importPath = _extractImportPath(line);
    if (importPath == null) continue;

    final targetFeature = _targetFeatureForImport(
      file: file,
      importPath: importPath,
    );
    if (targetFeature == null) continue;
    if (targetFeature != feature) {
      violations.add(
        Violation(
          ruleId: 'surface-imports-feature',
          path: path,
          line: i + 1,
          message: 'surface must not import feature $targetFeature',
          importPath: importPath,
        ),
      );
      hasViolations = true;
    }

    final resolvedPath = _resolveToLibPath(file, importPath);
    if (resolvedPath != null &&
        resolvedPath.startsWith('lib/core/') &&
        !_isAllowedCoreImport(resolvedPath)) {
      violations.add(
        Violation(
          ruleId: 'surface-imports-core-nonfoundation',
          path: path,
          line: i + 1,
          message: 'surface must not import core outside foundation',
          importPath: importPath,
        ),
      );
      hasViolations = true;
    }
  }
  return hasViolations;
}

bool _checkContractsFile(File file, List<Violation> violations) {
  if (_isGenerated(file)) return false;
  final path = file.path.replaceAll('\\', '/');
  if (!_isContractsFile(path)) return false;
  var hasViolation = false;

  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.startsWith('import')) {
      final importPath = _extractImportPath(line);
      if (importPath == null) continue;
      if (_isForbiddenContractsImport(importPath)) {
        violations.add(
          Violation(
            ruleId: 'contracts-forbidden-import',
            path: path,
            line: i + 1,
            message: 'contracts must not import $importPath',
            importPath: importPath,
          ),
        );
        hasViolation = true;
      }

      final resolvedPath = _resolveToLibPath(file, importPath);
      if (resolvedPath != null) {
        if (resolvedPath.startsWith('lib/features/')) {
          violations.add(
            Violation(
              ruleId: 'contracts-imports-features',
              path: path,
              line: i + 1,
              message: 'contracts must not import features',
              importPath: importPath,
            ),
          );
          hasViolation = true;
        }
        if (resolvedPath.startsWith('lib/core/')) {
          violations.add(
            Violation(
              ruleId: 'contracts-imports-core',
              path: path,
              line: i + 1,
              message: 'contracts must not import core',
              importPath: importPath,
            ),
          );
          hasViolation = true;
        }
      }
    }
  }

  final parseResult = parseFile(
    path: file.path,
    featureSet: FeatureSet.latestLanguageVersion(),
  );
  final unit = parseResult.unit;
  final visitor = _ContractsVisitor(
    path: path,
    lineInfo: unit.lineInfo,
    violations: violations,
  );
  unit.accept(visitor);
  hasViolation = hasViolation || visitor.hasViolations;

  return hasViolation;
}

String? _extractImportPath(String line) {
  final start = line.indexOf("'");
  final end = line.lastIndexOf("'");
  if (start == -1 || end == -1 || end <= start) return null;
  return line.substring(start + 1, end);
}

String? _targetFeatureForImport({
  required File file,
  required String importPath,
}) {
  if (importPath.startsWith('dart:')) return null;

  if (importPath.startsWith('package:kinly/features/')) {
    final parts = importPath.split('/');
    if (parts.length < 4) return null;
    return parts[2]; // package:kinly/features/<feature>/...
  }

  if (importPath.startsWith('package:')) return null;

  if (importPath.startsWith('.')) {
    final resolved = _resolveRelativeImport(file, importPath);
    if (resolved == null) return null;
    return _featureForPath(resolved);
  }

  return null;
}

String? _resolveRelativeImport(File file, String importPath) {
  try {
    final baseUri = file.parent.uri;
    final resolved = baseUri.resolve(importPath);
    return resolved.toFilePath().replaceAll('\\', '/');
  } catch (_) {
    return null;
  }
}

String? _resolveToLibPath(File file, String importPath) {
  if (importPath.startsWith('package:kinly/')) {
    final suffix = importPath.substring('package:kinly/'.length);
    return 'lib/$suffix';
  }
  if (importPath.startsWith('package:')) return null;
  if (importPath.startsWith('.')) {
    return _resolveRelativeImport(file, importPath);
  }
  return null;
}

bool _isAllowedCoreImport(String path) {
  for (final prefix in _allowedCorePrefixes) {
    if (path.startsWith(prefix)) return true;
  }
  return false;
}

bool _isForbiddenContractsImport(String importPath) {
  for (final pattern in _forbiddenContractsImports) {
    if (pattern.hasMatch(importPath)) return true;
  }
  return false;
}

bool _checkPlacementFile(File file, List<Violation> violations) {
  if (_isGenerated(file)) return false;
  final path = file.path.replaceAll('\\', '/');
  if (!path.startsWith('lib/core/')) return false;
  if (_isAllowedCoreImport(path)) return false;

  final parseResult = parseFile(
    path: file.path,
    featureSet: FeatureSet.latestLanguageVersion(),
  );
  final unit = parseResult.unit;
  final visitor = _PlacementVisitor(
    path: path,
    lineInfo: unit.lineInfo,
    violations: violations,
    checkModelHeuristic: _shouldCheckModelPlacement(path),
  );
  unit.accept(visitor);
  return visitor.hasViolations;
}

bool _shouldCheckModelPlacement(String path) {
  final normalized = path.replaceAll('\\', '/');
  return normalized.contains('/models/') ||
      normalized.endsWith('/models.dart') ||
      normalized.endsWith('_models.dart');
}

String? _coreDomainForPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  final coreIndex = parts.indexOf('core');
  if (coreIndex == -1 || coreIndex + 1 >= parts.length) return null;
  return parts[coreIndex + 1];
}

class _ContractsVisitor extends RecursiveAstVisitor<void> {
  _ContractsVisitor({
    required this.path,
    required this.lineInfo,
    required this.violations,
  });

  final String path;
  final LineInfo lineInfo;
  final List<Violation> violations;
  bool hasViolations = false;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final isAbstract = node.abstractKeyword != null;
    if (isAbstract) {
      _checkAbstractClass(node);
    } else {
      _checkDtoClass(node);
    }
    super.visitClassDeclaration(node);
  }

  void _checkAbstractClass(ClassDeclaration node) {
    for (final member in node.members) {
      if (member is MethodDeclaration) {
        if (!_isAbstractBody(member.body)) {
          _addViolation(
            member,
            'ports must not define method bodies in abstract classes',
            'contracts-abstract-method-body',
          );
        }
      }
    }
  }

  void _checkDtoClass(ClassDeclaration node) {
    for (final member in node.members) {
      if (member is FieldDeclaration) {
        final isStatic = member.isStatic;
        final isFinal = member.fields.isFinal || member.fields.isConst;
        if (!isStatic && !isFinal) {
          _addViolation(member, 'DTO fields must be final', 'contracts-dto-field');
        }
      } else if (member is MethodDeclaration) {
        if (!_isAllowedDtoMethod(member)) {
          _addViolation(
            member,
            'DTOs must not define methods except constructors, toJson/fromJson, props, or copyWith',
            'contracts-dto-method',
          );
        }
      } else if (member is ConstructorDeclaration) {
        // Always allowed (const/named/unnamed).
      }
    }
  }

  bool _isAllowedDtoMethod(MethodDeclaration method) {
    if (method.isGetter) {
      return method.name.lexeme == 'props';
    }

    final name = method.name.lexeme;
    if (name == 'toJson' || name == 'copyWith') {
      return true;
    }
    if (method.isStatic && (name == 'fromJson' || name == 'fromModel')) {
      return true;
    }
    return false;
  }

  bool _isAbstractBody(FunctionBody body) {
    return body is EmptyFunctionBody;
  }

  void _addViolation(AstNode node, String message, String ruleId) {
    final line = lineInfo.getLocation(node.offset).lineNumber;
    violations.add(
      Violation(
        ruleId: ruleId,
        path: path,
        line: line,
        message: message,
      ),
    );
    hasViolations = true;
  }
}

class _PlacementVisitor extends RecursiveAstVisitor<void> {
  _PlacementVisitor({
    required this.path,
    required this.lineInfo,
    required this.violations,
    required this.checkModelHeuristic,
  });

  final String path;
  final LineInfo lineInfo;
  final List<Violation> violations;
  final bool checkModelHeuristic;
  bool hasViolations = false;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.name.lexeme;
    if (node.abstractKeyword != null && _portNamePattern.hasMatch(name)) {
      _addViolation(
        node,
        'ports must live in lib/contracts/** (found $name)',
        'core-ports',
      );
    } else if (checkModelHeuristic && node.abstractKeyword == null) {
      final suffix = _dtoSuffixes.firstWhere(
        (candidate) => name.endsWith(candidate),
        orElse: () => '',
      );
      final domain = _coreDomainForPath(path) ?? 'domain';
      if (suffix.isNotEmpty) {
        _addViolation(
          node,
          'DTO $name should move to lib/contracts/$domain/**',
          'core-dto-placement',
        );
      } else {
        _addViolation(
          node,
          'model $name should move to lib/features/$domain/domain/**',
          'core-model-placement',
        );
      }
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    final name = node.name.lexeme;
    if (_portNamePattern.hasMatch(name)) {
      _addViolation(
        node,
        'ports must live in lib/contracts/** (found $name)',
        'core-ports',
      );
    }
    super.visitGenericTypeAlias(node);
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    final name = node.name.lexeme;
    if (_portNamePattern.hasMatch(name)) {
      _addViolation(
        node,
        'ports must live in lib/contracts/** (found $name)',
        'core-ports',
      );
    }
    super.visitFunctionTypeAlias(node);
  }

  void _addViolation(AstNode node, String message, String ruleId) {
    final line = lineInfo.getLocation(node.offset).lineNumber;
    violations.add(
      Violation(
        ruleId: ruleId,
        path: path,
        line: line,
        message: message,
      ),
    );
    hasViolations = true;
  }
}

void _printStrictSummary(List<Violation> violations) {
  final byRule = <String, List<Violation>>{};
  for (final v in violations) {
    byRule.putIfAbsent(v.ruleId, () => []).add(v);
  }

  stderr.writeln('Composable system violations (${violations.length}):');
  for (final entry in byRule.entries) {
    stderr.writeln('Rule ${entry.key}: ${entry.value.length}');
    if (entry.key == 'feature-cross-import') {
      final edges = <String, List<Violation>>{};
      for (final v in entry.value) {
        final from = v.sourceFeature ?? 'unknown';
        final to = v.targetFeature ?? 'unknown';
        edges.putIfAbsent('$from -> $to', () => []).add(v);
      }
      for (final edge in edges.entries) {
        stderr.writeln('  Edge ${edge.key}: ${edge.value.length}');
        final files = <String, int>{};
        for (final v in edge.value) {
          files[v.path] = (files[v.path] ?? 0) + 1;
        }
        final sortedFiles =
            files.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
        for (final fileEntry in sortedFiles.take(3)) {
          stderr.writeln('    ${fileEntry.key}: ${fileEntry.value}');
        }
      }
    }
  }

  stderr.writeln('Violations:');
  for (final v in violations) {
    stderr.writeln(' - ${v.formatLine()}');
  }

  stderr.writeln(
    'Found ${violations.length} violations across ${byRule.length} rules. CI failed.',
  );
}
