import 'dart:io';

/// Fails if any color token declared in lib/core/theme/color_tokens.dart
/// is not referenced outside that file.
void main() async {
  final tokensFile = File('lib/core/theme/color_tokens.dart');
  if (!tokensFile.existsSync()) {
    stderr.writeln('color_tokens.dart not found');
    exit(1);
  }

  final content = tokensFile.readAsLinesSync();
  final tokenRegex = RegExp(r'final Color (\w+);');
  final tokens = <String>[];
  for (final line in content) {
    final m = tokenRegex.firstMatch(line);
    if (m != null) tokens.add(m.group(1)!);
  }

  final unused = <String>[];
  final libDir = Directory('lib');

  bool fileUsesToken(File file, String token) {
    final text = file.readAsStringSync();
    return RegExp(r'\b' + RegExp.escape(token) + r'\b').hasMatch(text);
  }

  bool tokenUsed(String token) {
    final queue = <Directory>[libDir];
    while (queue.isNotEmpty) {
      final dir = queue.removeLast();
      for (final entity in dir.listSync()) {
        if (entity is Directory) {
          queue.add(entity);
          continue;
        }
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        if (entity.path
            .replaceAll('\\', '/')
            .endsWith('lib/core/theme/color_tokens.dart')) {
          continue;
        }
        if (fileUsesToken(entity, token)) return true;
      }
    }
    return false;
  }

  for (final name in tokens) {
    if (!tokenUsed(name)) {
      unused.add(name);
    }
  }

  if (unused.isNotEmpty) {
    stderr.writeln('Unused color tokens: ${unused.join(', ')}');
    exit(1);
  }

  stdout.writeln('All color tokens are referenced.');
}
