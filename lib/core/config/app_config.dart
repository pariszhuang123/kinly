class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const deeplinkHost = String.fromEnvironment('DEEPLINK_HOST');
  // Optional: for native Google Sign-In flow (not needed for Supabase PKCE)
  static const webClientId = String.fromEnvironment('WEB_CLIENT_ID');
  static const iosClientId = String.fromEnvironment('IOS_CLIENT_ID');

  static void validate() {
    final missing = <String>[];
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (deeplinkHost.isEmpty) missing.add('DEEPLINK_HOST');
    if (missing.isNotEmpty) {
      throw StateError('Missing dart-define(s): ${missing.join(', ')}');
    }
  }
}
