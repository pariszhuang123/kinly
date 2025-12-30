import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

const _maxDepth = 3;
const _exceptionTag = "@guardrail-exception: nesting-depth";

void main() {
  final violations = <String>[];
  final files =
      _dartFilesUnder('lib').where((f) => !_isGenerated(f)).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    _checkFile(file, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln("Nesting depth guardrails passed");
    return;
  }

  stdout.writeln("Nesting depth guardrails failed (${violations.length}):");
  for (final v in violations) {
    stdout.writeln(" - $v");
  }
  exitCode = 1;
}

Iterable<File> _dartFilesUnder(String root) sync* {
  final rootDir = Directory(root);
  if (!rootDir.existsSync()) return;
  for (final entry in rootDir.listSync(recursive: true, followLinks: false)) {
    if (entry is File && entry.path.endsWith(".dart")) {
      yield entry;
    }
  }
}

bool _isGenerated(File file) {
  final path = file.path.replaceAll("\\", "/");
  return path.contains("/generated/") ||
      path.endsWith(".g.dart") ||
      path.endsWith(".freezed.dart");
}

void _checkFile(File file, List<String> violations) {
  final content = file.readAsStringSync();
  final result = parseString(
    path: file.path,
    throwIfDiagnostics: false,
    content: content,
  );

  final visitor = _NestingVisitor(
    file.path.replaceAll("\\", "/"),
    content.split('\n'),
    result.lineInfo,
    violations,
  );
  result.unit.visitChildren(visitor);
}

class _NestingVisitor extends RecursiveAstVisitor<void> {
  _NestingVisitor(this.path, this.lines, this.lineInfo, this.violations);

  final String path;
  final List<String> lines;
  final LineInfo lineInfo;
  final List<String> violations;

  final List<_FunctionContext> _stack = [];

  _FunctionContext get _current => _stack.last;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    _withFunction(name, node.functionExpression, isClosure: false);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;
    _withFunction(name, node.body, isClosure: false);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    _withFunction("<closure>", node.body, isClosure: true);
  }

  @override
  void visitIfStatement(IfStatement node) =>
      _withNest(() => super.visitIfStatement(node));

  @override
  void visitForStatement(ForStatement node) =>
      _withNest(() => super.visitForStatement(node));

  @override
  @override
  void visitWhileStatement(WhileStatement node) =>
      _withNest(() => super.visitWhileStatement(node));

  @override
  void visitDoStatement(DoStatement node) =>
      _withNest(() => super.visitDoStatement(node));

  @override
  void visitSwitchStatement(SwitchStatement node) =>
      _withNest(() => super.visitSwitchStatement(node));

  @override
  void visitTryStatement(TryStatement node) =>
      _withNest(() => super.visitTryStatement(node));

  void _withFunction(String name, AstNode body, {required bool isClosure}) {
    final start = lineInfo.getLocation(body.offset).lineNumber;
    final exempt = _hasExceptionTagNear(start);
    final parentDepth = _stack.isEmpty ? 0 : _current.currentDepth;
    final context = _FunctionContext(
      name: name,
      startLine: start,
      currentDepth: parentDepth + (isClosure ? 1 : 0),
      exempt: exempt,
    );
    context.maxDepth = context.currentDepth;

    _stack.add(context);
    body.visitChildren(this);
    _stack.removeLast();

    if (!context.exempt && context.maxDepth > _maxDepth) {
      violations.add(
        "$path:${context.startLine} ${context.displayName} nesting depth ${context.maxDepth} > $_maxDepth",
      );
    }
  }

  void _withNest(void Function() visit) {
    if (_stack.isEmpty) {
      visit();
      return;
    }
    _current.currentDepth += 1;
    if (_current.currentDepth > _current.maxDepth) {
      _current.maxDepth = _current.currentDepth;
    }
    visit();
    _current.currentDepth -= 1;
  }

  bool _hasExceptionTagNear(int startLine) {
    final startIndex = (startLine - 3).clamp(0, lines.length - 1);
    final endIndex = startLine.clamp(0, lines.length);
    for (var i = startIndex; i < endIndex; i++) {
      if (lines[i].contains(_exceptionTag)) {
        return true;
      }
    }
    return false;
  }
}

class _FunctionContext {
  _FunctionContext({
    required this.name,
    required this.startLine,
    required this.currentDepth,
    required this.exempt,
  });

  final String name;
  final int startLine;
  int currentDepth;
  int maxDepth = 0;
  final bool exempt;

  String get displayName => name == "<closure>" ? "closure" : "function $name";
}
