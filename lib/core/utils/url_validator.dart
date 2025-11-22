bool isValidHttpUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return false;

  final scheme = uri.scheme.toLowerCase();
  final hasValidScheme = scheme == 'http' || scheme == 'https';
  return hasValidScheme && uri.host.isNotEmpty;
}

String? normalizeHttpUrlOrNull(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return isValidHttpUrl(trimmed) ? trimmed : null;
}
