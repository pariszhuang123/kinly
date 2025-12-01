/// Appends/updates a cache-busting query parameter to avatar URLs so clients
/// fetch the latest image when the underlying avatar asset changes.
///
/// We use a stable `version` token (e.g., storage path or avatar id) so the
/// URL only changes when the avatar really changes, avoiding unnecessary
/// reloads across screens.
String? cacheBustAvatarUrl(String? url, {String? version}) {
  if (url == null || url.isEmpty || version == null || version.isEmpty) {
    return url;
  }

  final uri = Uri.parse(url);
  final updatedParams = Map<String, String>.from(uri.queryParameters);

  if (updatedParams['v'] == version) return url;

  updatedParams['v'] = version;
  return uri.replace(queryParameters: updatedParams).toString();
}
