import 'dart:io';

final _featureImport = RegExp(r"^package:kinly/features/([^/]+)/(.+)");
final _featureUiImport = RegExp(r"^package:kinly/features/([^/]+)/ui/");
final _allowedRouterFeatureImports = {
  'version_gating/bloc/app_version_cubit.dart',
};

void main() {
  final violations = <String>[];
  final files =
      _dartFilesUnder('lib').where((f) => !_isGenerated(f)).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    _checkFile(file, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln("Dependency guardrails passed");
    return;
  }

  stdout.writeln("Dependency guardrails failed (${violations.length}):");
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

String? _featureForPath(String path) {
  final normalized = path.replaceAll("\\", "/");
  final parts = normalized.split("/");
  final featureIndex = parts.indexOf("features");
  if (featureIndex == -1 || featureIndex + 1 >= parts.length) return null;
  return parts[featureIndex + 1];
}

String? _layerForPath(String path) {
  final normalized = path.replaceAll("\\", "/");
  if (normalized.contains("/ui/")) return "ui";
  if (normalized.contains("/bloc/")) return "bloc";
  if (normalized.contains("/domain/")) return "domain";
  if (normalized.contains("/data/")) return "data";
  return null;
}

bool _isTestFile(String path) {
  final normalized = path.replaceAll("\\", "/");
  return normalized.startsWith("test/") ||
      normalized.contains("/test/") ||
      normalized.startsWith("integration_test/") ||
      normalized.contains("/integration_test/");
}

void _checkFile(File file, List<String> violations) {
  final path = file.path.replaceAll("\\", "/");
  final isCore = path.startsWith("lib/core/");
  final isRouter = path.startsWith("lib/app/router/");
  final feature = _featureForPath(path);
  final layer = _layerForPath(path);
  final isSharedData = path.startsWith("lib/data/");
  final isTestFile = _isTestFile(path);

  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (!line.startsWith("import")) continue;
    final importPath = _extractImportPath(line);
    if (importPath == null) continue;

    if (isCore && importPath.contains("/features/")) {
      violations.add(
        "$path:${i + 1} core cannot import features ($importPath)",
      );
    }

    final featureUiMatch = _featureUiImport.firstMatch(importPath);
    if (featureUiMatch != null) {
      if (isRouter) {
        violations.add(
          "$path:${i + 1} router must not import feature UI ($importPath)",
        );
        continue;
      }
      final targetFeature = featureUiMatch.group(1)!;
      final isSameFeature = feature == targetFeature;
      final isAllowed = isSameFeature || isTestFile;
      if (!isAllowed) {
        violations.add(
          "$path:${i + 1} only router may import feature UI ($importPath)",
        );
      }
    }

    if (feature != null) {
      _checkFeatureImport(
        path: path,
        lineNumber: i + 1,
        feature: feature,
        layer: layer,
        importPath: importPath,
        isTestFile: isTestFile,
        violations: violations,
      );
    }

    if (isRouter) {
      final match = _featureImport.firstMatch(importPath);
      if (match != null) {
        final featureName = match.group(1)!;
        final rest = match.group(2)!;
        final fullPath = "$featureName/$rest";
        if (!rest.startsWith("routes/") &&
            !_allowedRouterFeatureImports.contains(fullPath)) {
          violations.add(
            "$path:${i + 1} router must import features/**/routes only ($importPath)",
          );
        }
      }
      if (importPath.startsWith("package:kinly/foundation/") &&
          !importPath.contains("/routes/")) {
        violations.add(
          "$path:${i + 1} router must import foundation routes only ($importPath)",
        );
      }
    }

    if (isSharedData && importPath.contains("/features/")) {
      violations.add(
        "$path:${i + 1} shared data must not depend on feature internals ($importPath)",
      );
    }
  }
}

String? _extractImportPath(String line) {
  final start = line.indexOf("'");
  final end = line.lastIndexOf("'");
  if (start == -1 || end == -1 || end <= start) return null;
  return line.substring(start + 1, end);
}

void _checkFeatureImport({
  required String path,
  required int lineNumber,
  required String feature,
  required String? layer,
  required String importPath,
  required bool isTestFile,
  required List<String> violations,
}) {
  final match = _featureImport.firstMatch(importPath);
  if (match != null) {
    final targetFeature = match.group(1)!;
    final rest = match.group(2)!;

    final isSameFeature = targetFeature == feature;
    final isTestingBarrel = rest.contains("_testing.dart");
    final isPublicBarrel = rest == "$targetFeature.dart";

    if (!isSameFeature) {
      if (isTestingBarrel && isTestFile) {
        return;
      }
      if (!isPublicBarrel) {
        violations.add(
          "$path:$lineNumber cross-feature import must use barrel (got $importPath)",
        );
      }
      return;
    }

    // Same-feature layer checks.
    if (layer == "ui" && importPath.contains("/data/")) {
      violations.add("$path:$lineNumber UI must not import data ($importPath)");
    }
    if (layer == "bloc" && importPath.contains("/data/")) {
      violations.add(
        "$path:$lineNumber BLoC must not import data ($importPath)",
      );
    }
    if (layer == "domain") {
      if (importPath.startsWith("package:flutter") ||
          importPath.contains("flutter_bloc") ||
          importPath.contains("supabase") ||
          importPath.contains("http") ||
          importPath.contains("shared_preferences") ||
          importPath.contains("google_sign_in")) {
        violations.add(
          "$path:$lineNumber domain must remain platform/pure-Dart (got $importPath)",
        );
      }
    }
  } else if (layer == "domain") {
    // Domain should not import Flutter/platform even via relative paths.
    if (importPath.startsWith("package:flutter") ||
        importPath.contains("flutter_bloc") ||
        importPath.contains("supabase") ||
        importPath.contains("http") ||
        importPath.contains("shared_preferences") ||
        importPath.contains("google_sign_in")) {
      violations.add(
        "$path:$lineNumber domain must remain platform/pure-Dart (got $importPath)",
      );
    }
  }
}
