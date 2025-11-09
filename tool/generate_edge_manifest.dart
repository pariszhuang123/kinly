import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final dir = Directory('supabase/functions');
  final manifest = <String, dynamic>{'functions': <String, dynamic>{}};
  if (await dir.exists()) {
    await for (final entry in dir.list(recursive: false, followLinks: false)) {
      if (entry is Directory) {
        final name =
            entry.uri.pathSegments.isNotEmpty
                ? entry.uri.pathSegments.last.replaceAll('/', '')
                : entry.path.split(Platform.pathSeparator).last;
        manifest['functions'][name] = {
          'path': entry.path.replaceAll('\\', '/'),
        };
      }
    }
  }
  final out = File('docs/contracts/edge_functions.json');
  out.createSync(recursive: true);
  out.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  stdout.writeln('Wrote ${out.path}');
}
