import 'dart:convert';
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

void main(List<String> args) {
  final cli = _CliArgs.parse(args);
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Unable to locate lib/ from ${Directory.current.path}');
    exit(1);
  }

  final collector = _ProjectCollector();
  for (final file in libDir.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    final normalizedPath = file.path.replaceAll('\\', '/');
    if (_excludedSegments.any(normalizedPath.contains)) continue;

    final raw = file.readAsStringSync();
    final parsed = parseString(
      path: file.path,
      content: raw,
      throwIfDiagnostics: false,
    );
    parsed.unit.accept(
      _FunctionCollector(
        normalizedPath: normalizedPath,
        content: raw,
        lineInfo: parsed.unit.lineInfo,
        sink: collector,
      ),
    );
  }

  final report = collector.buildReport();
  if (cli.baselinePath != null) {
    final baselineFile = File(cli.baselinePath!);
    if (baselineFile.existsSync()) {
      try {
        final baseline = jsonDecode(baselineFile.readAsStringSync());
        report.attachBaseline(baseline);
      } catch (_) {
        stderr.writeln(
          'Baseline ${cli.baselinePath} is not valid JSON; skipping delta.',
        );
      }
    } else {
      stderr.writeln('Baseline ${cli.baselinePath} not found; skipping delta.');
    }
  }

  final outFile = File(cli.outPath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(jsonEncode(report.toJson()));

  if (cli.txtPath != null) {
    final txt = _formatHuman(report);
    final txtFile = File(cli.txtPath!);
    txtFile.parent.createSync(recursive: true);
    txtFile.writeAsStringSync(txt);
  }

  stdout.writeln('Complexity hotspot report written to ${outFile.path}');
  if (cli.txtPath != null) {
    stdout.writeln('Human summary written to ${cli.txtPath}');
  }
}

String _formatHuman(_Report report) {
  final buffer =
      StringBuffer()
        ..writeln('Complexity Hotspots')
        ..writeln('Total complexity: ${report.totalComplexity}')
        ..writeln('Functions (top ${report.topFunctions.length}):');
  for (final fn in report.topFunctions) {
    buffer.writeln(
      ' - CC ${fn.complexity.toString().padLeft(3)} | ${fn.displayName} @ ${fn.path}:${fn.line}${fn.isBlocHandler ? " [BLoC]" : ""}',
    );
  }
  buffer.writeln('Files (top ${report.topFiles.length}):');
  for (final file in report.topFiles) {
    buffer.writeln(
      ' - CC ${file.complexity.toString().padLeft(3)} | ${file.path}',
    );
  }
  if (report.baselineDelta != null) {
    buffer.writeln(
      'Baseline delta (total): ${report.baselineDelta! >= 0 ? "+" : ""}${report.baselineDelta}',
    );
  }
  return buffer.toString();
}

class _CliArgs {
  _CliArgs({
    required this.outPath,
    required this.txtPath,
    required this.baselinePath,
  });

  factory _CliArgs.parse(List<String> args) {
    String outPath = 'build/complexity_report.json';
    String? txtPath = 'build/complexity_report.txt';
    String? baselinePath;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--out':
          if (i + 1 < args.length) outPath = args[++i];
          break;
        case '--txt':
          if (i + 1 < args.length) txtPath = args[++i];
          break;
        case '--baseline':
          if (i + 1 < args.length) baselinePath = args[++i];
          break;
        case '--no-txt':
          txtPath = null;
          break;
      }
    }

    return _CliArgs(
      outPath: outPath,
      txtPath: txtPath,
      baselinePath: baselinePath,
    );
  }

  final String outPath;
  final String? txtPath;
  final String? baselinePath;
}

class _ProjectCollector implements _Sink {
  final functions = <_FunctionComplexity>[];

  @override
  void addFunction(_FunctionComplexity fn) => functions.add(fn);

  _Report buildReport() {
    final total = functions.fold<int>(0, (sum, f) => sum + f.complexity);
    final byFile = <String, int>{};
    for (final fn in functions) {
      byFile.update(
        fn.path,
        (value) => value + fn.complexity,
        ifAbsent: () => fn.complexity,
      );
    }
    final topFunctions = [...functions]
      ..sort((a, b) => b.complexity.compareTo(a.complexity));
    final topFiles =
        byFile.entries
            .map((e) => _FileComplexity(path: e.key, complexity: e.value))
            .toList()
          ..sort((a, b) => b.complexity.compareTo(a.complexity));
    return _Report(
      totalComplexity: total,
      topFunctions: topFunctions.take(10).toList(),
      topFiles: topFiles.take(10).toList(),
    );
  }
}

class _Report {
  _Report({
    required this.totalComplexity,
    required this.topFunctions,
    required this.topFiles,
  }) : baselineDelta = null;

  final int totalComplexity;
  final List<_FunctionComplexity> topFunctions;
  final List<_FileComplexity> topFiles;
  int? baselineDelta;

  void attachBaseline(Map<String, dynamic> baseline) {
    final baselineTotal = baseline['totalComplexity'];
    if (baselineTotal is int) {
      baselineDelta = totalComplexity - baselineTotal;
    }
  }

  Map<String, dynamic> toJson() => {
    'totalComplexity': totalComplexity,
    if (baselineDelta != null) 'baselineDelta': baselineDelta,
    'topFunctions': topFunctions.map((f) => f.toJson()).toList(),
    'topFiles': topFiles.map((f) => f.toJson()).toList(),
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
  };
}

class _FunctionCollector extends RecursiveAstVisitor<void> {
  _FunctionCollector({
    required this.normalizedPath,
    required this.content,
    required this.lineInfo,
    required this.sink,
  }) : lines = content.split('\n');

  final String normalizedPath;
  final String content;
  final LineInfo lineInfo;
  final List<String> lines;
  final _Sink sink;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    final isBlocHandler = _looksLikeBlocHandler(name);
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
    final isBlocHandler = _looksLikeBlocHandler(node.name.lexeme);
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
    sink.addFunction(
      _FunctionComplexity(
        path: normalizedPath,
        displayName: displayName,
        line: location.lineNumber,
        complexity: counter.complexity,
        isBlocHandler: isBlocHandler,
      ),
    );
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
  });

  final String path;
  final String displayName;
  final int line;
  final int complexity;
  final bool isBlocHandler;

  Map<String, dynamic> toJson() => {
    'path': path,
    'displayName': displayName,
    'line': line,
    'complexity': complexity,
    'isBlocHandler': isBlocHandler,
  };
}

class _FileComplexity {
  _FileComplexity({required this.path, required this.complexity});

  final String path;
  final int complexity;

  Map<String, dynamic> toJson() => {'path': path, 'complexity': complexity};
}

abstract class _Sink {
  void addFunction(_FunctionComplexity fn);
}

bool _looksLikeBlocHandler(String name) {
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
