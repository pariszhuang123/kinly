import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

const _excludedSegments = <String>[
  '.g.dart',
  '.freezed.dart',
  '.gr.dart',
  '/generated/',
];

const _functionLimits = _Limits(target: 10, warnStart: 11, hardCap: 16);

const _blocHandlerLimits = _Limits(target: 12, warnStart: 13, hardCap: 18);

const _fileLimits = _Limits(target: 60, warnStart: 61, hardCap: 91);

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Unable to locate lib/ from ${Directory.current.path}');
    exit(1);
  }

  final warnings = <String>[];
  final errors = <String>[];

  for (final entity
      in libDir.listSync(recursive: true).whereType<File>().toList()) {
    if (!entity.path.endsWith('.dart')) continue;
    final normalizedPath = entity.path.replaceAll('\\', '/');
    if (_excludedSegments.any(normalizedPath.contains)) continue;

    final raw = entity.readAsStringSync();
    final parseResult = parseString(
      content: raw,
      path: entity.path,
      throwIfDiagnostics: false,
    );
    final unit = parseResult.unit;
    final collector = _FunctionCollector(
      normalizedPath: normalizedPath,
      content: raw,
      lineInfo: unit.lineInfo,
    );
    unit.accept(collector);

    final fileComplexity = collector.functions.fold<int>(
      0,
      (total, f) => total + f.complexity,
    );

    if (fileComplexity >= _fileLimits.hardCap) {
      errors.add(
        '$normalizedPath file CC=$fileComplexity (hard cap ${_fileLimits.hardCap - 1}).',
      );
    } else if (fileComplexity >= _fileLimits.warnStart) {
      warnings.add(
        '$normalizedPath file CC=$fileComplexity (soft band ${_fileLimits.warnStart}-${_fileLimits.hardCap - 1}); ensure UI-only composition.',
      );
    }

    for (final fn in collector.functions) {
      if (fn.exception != null && fn.exception!.isExpired) {
        errors.add(
          '${fn.displayName} @ ${fn.path}:${fn.line} has expired CC_BUDGET_EXCEPTION (${fn.exception!.raw}).',
        );
        continue;
      }

      final limits = fn.isBlocHandler ? _blocHandlerLimits : _functionLimits;
      if (fn.complexity >= limits.hardCap) {
        errors.add(
          '${fn.displayName} @ ${fn.path}:${fn.line} CC=${fn.complexity} exceeds hard cap ${limits.hardCap - 1}.',
        );
      } else if (fn.complexity >= limits.warnStart) {
        final scope = fn.isBlocHandler ? 'BLoC handler' : 'function';
        final note =
            fn.exception != null
                ? ' (has exception: ${fn.exception!.raw})'
                : '';
        warnings.add(
          '$scope CC=${fn.complexity} ${fn.displayName} @ ${fn.path}:${fn.line} in soft band ${limits.warnStart}-${limits.hardCap - 1}$note.',
        );
      }
    }
  }

  if (warnings.isNotEmpty) {
    stdout.writeln('Complexity warnings (non-blocking):');
    for (final warning in warnings) {
      stdout.writeln('- $warning');
    }
  }

  if (errors.isEmpty) {
    stdout.writeln('Complexity budget check passed.');
    exit(0);
  }

  stderr.writeln('Complexity budget violations:');
  for (final error in errors) {
    stderr.writeln('- $error');
  }
  exit(1);
}

class _FunctionCollector extends RecursiveAstVisitor<void> {
  _FunctionCollector({
    required this.normalizedPath,
    required this.content,
    required this.lineInfo,
  }) : lines = content.split('\n');

  final String normalizedPath;
  final String content;
  final LineInfo lineInfo;
  final List<String> lines;

  final functions = <_FunctionComplexity>[];

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    final isBlocHandler = _looksLikeBlocHandler(name, node.parent);
    _recordFunction(
      displayName: name,
      body: node.functionExpression.body,
      nodeOffset: node.offset,
      isBlocHandler: isBlocHandler,
    );
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final className =
        (node.parent is ClassDeclaration)
            ? (node.parent as ClassDeclaration).name.lexeme
            : null;
    final baseName =
        className != null ? '$className.${node.name.lexeme}' : node.name.lexeme;
    final isBlocHandler = _looksLikeBlocHandler(node.name.lexeme, node.parent);
    _recordFunction(
      displayName: baseName,
      body: node.body,
      nodeOffset: node.offset,
      isBlocHandler: isBlocHandler,
    );
    super.visitMethodDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    final className = node.returnType.name;
    final nameSuffix = node.name?.lexeme ?? '';
    final name = nameSuffix.isEmpty ? className : '$className.$nameSuffix';
    _recordFunction(
      displayName: name,
      body: node.body,
      nodeOffset: node.offset,
      isBlocHandler: false,
    );
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (node.parent is FunctionDeclaration ||
        node.parent is MethodDeclaration ||
        node.parent is ConstructorDeclaration) {
      super.visitFunctionExpression(node);
      return;
    }
    final displayName = _deriveFunctionExpressionName(node);
    final isBlocHandler = _looksLikeBlocInlineHandler(node);
    _recordFunction(
      displayName: displayName,
      body: node.body,
      nodeOffset: node.offset,
      isBlocHandler: isBlocHandler,
    );
    super.visitFunctionExpression(node);
  }

  void _recordFunction({
    required String displayName,
    required FunctionBody body,
    required int nodeOffset,
    required bool isBlocHandler,
  }) {
    final counter = _ComplexityVisitor();
    body.accept(counter);
    final location = lineInfo.getLocation(nodeOffset);
    final exception = _parseException(location.lineNumber);
    functions.add(
      _FunctionComplexity(
        path: normalizedPath,
        displayName: displayName,
        line: location.lineNumber,
        complexity: counter.complexity,
        isBlocHandler: isBlocHandler,
        exception: exception,
      ),
    );
  }

  _ExceptionMeta? _parseException(int startLine) {
    for (var i = startLine - 2; i >= 0 && i >= startLine - 4; i--) {
      if (i >= lines.length) continue;
      final line = lines[i].trim();
      if (line.startsWith('// CC_BUDGET_EXCEPTION')) {
        final expiry = RegExp(
          r'expires:\s*([0-9]{4}-[0-9]{2}-[0-9]{2})',
        ).firstMatch(line);
        final expiresAt =
            expiry != null ? DateTime.tryParse(expiry.group(1)!) : null;
        final now = DateTime.now().toUtc();
        final expired = expiresAt != null && now.isAfter(expiresAt.toUtc());
        return _ExceptionMeta(
          raw: line.replaceFirst('//', '').trim(),
          isExpired: expired || expiresAt == null,
        );
      }
      if (line.isNotEmpty && !line.startsWith('//')) break;
    }
    return null;
  }

  String _deriveFunctionExpressionName(FunctionExpression node) {
    final location = lineInfo.getLocation(node.offset);
    if (node.parent is VariableDeclaration) {
      return (node.parent as VariableDeclaration).name.lexeme;
    }
    if (node.parent is NamedExpression) {
      final name = (node.parent as NamedExpression).name.label.name;
      return '$name@${location.lineNumber}';
    }
    if (node.parent is ArgumentList) {
      final argList = node.parent as ArgumentList;
      final target = argList.parent;
      if (target is MethodInvocation) {
        return '${target.methodName.name} callback@${location.lineNumber}';
      }
    }
    return 'closure@${location.lineNumber}';
  }
}

class _ComplexityVisitor extends RecursiveAstVisitor<void> {
  int complexity = 1;

  @override
  void visitIfStatement(IfStatement node) {
    complexity++;
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    complexity++;
    super.visitForStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    complexity++;
    super.visitWhileStatement(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    complexity++;
    super.visitDoStatement(node);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    for (final _ in node.members) {
      complexity++;
    }
    super.visitSwitchStatement(node);
  }

  @override
  void visitSwitchExpression(SwitchExpression node) {
    for (final _ in node.cases) {
      complexity++;
    }
    super.visitSwitchExpression(node);
  }

  @override
  void visitForElement(ForElement node) {
    complexity++;
    super.visitForElement(node);
  }

  @override
  void visitIfElement(IfElement node) {
    complexity++;
    super.visitIfElement(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    complexity++;
    super.visitCatchClause(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    if (node.operator.type == TokenType.BAR_BAR ||
        node.operator.type == TokenType.AMPERSAND_AMPERSAND) {
      complexity++;
    }
    super.visitBinaryExpression(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    complexity++;
    super.visitConditionalExpression(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    // Nested functions are counted separately, not against the parent.
  }
}

class _FunctionComplexity {
  _FunctionComplexity({
    required this.path,
    required this.displayName,
    required this.line,
    required this.complexity,
    required this.isBlocHandler,
    required this.exception,
  });

  final String path;
  final String displayName;
  final int line;
  final int complexity;
  final bool isBlocHandler;
  final _ExceptionMeta? exception;
}

class _ExceptionMeta {
  _ExceptionMeta({required this.raw, required this.isExpired});

  final String raw;
  final bool isExpired;
}

class _Limits {
  const _Limits({
    required this.target,
    required this.warnStart,
    required this.hardCap,
  });

  final int target;
  final int warnStart;
  final int hardCap;
}

bool _looksLikeBlocHandler(String name, AstNode? parent) {
  if (name == 'mapEventToState' || name == 'mapEventToStateWithTransition') {
    return true;
  }
  return name.startsWith('_on');
}

bool _looksLikeBlocInlineHandler(FunctionExpression node) {
  final parent = node.parent;
  if (parent is ArgumentList && parent.parent is MethodInvocation) {
    final invocation = parent.parent as MethodInvocation;
    if (invocation.methodName.name == 'on') {
      return true;
    }
  }
  return false;
}
