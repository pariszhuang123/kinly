class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const deeplinkHost = String.fromEnvironment('DEEPLINK_HOST');
  static const revenuecatIosKey =
      String.fromEnvironment('REVENUECAT_IOS_KEY', defaultValue: '');
  static const revenuecatAndroidKey =
      String.fromEnvironment('REVENUECAT_ANDROID_KEY', defaultValue: '');
  // Placeholder for public invite host (e.g., makinglifeeasie.com); falls back
  // to deeplinkHost if empty.
  static const inviteHost = String.fromEnvironment('INVITE_HOST');
  // Optional: for native Google Sign-In flow (not needed for Supabase PKCE)
  static const webClientId = String.fromEnvironment('WEB_CLIENT_ID');
  static const iosClientId = String.fromEnvironment('IOS_CLIENT_ID');
  static const iosStoreUrl = String.fromEnvironment('IOS_STORE_URL');
  static const androidStoreUrl = String.fromEnvironment('ANDROID_STORE_URL');

  static void validate() {
    final missing = <String>[];
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (deeplinkHost.isEmpty) missing.add('DEEPLINK_HOST');
    if (iosStoreUrl.isEmpty) missing.add('IOS_STORE_URL');
    if (androidStoreUrl.isEmpty) missing.add('ANDROID_STORE_URL');
    if (revenuecatIosKey.isEmpty) missing.add('REVENUECAT_IOS_KEY');
    if (revenuecatAndroidKey.isEmpty) missing.add('REVENUECAT_ANDROID_KEY');
    if (missing.isNotEmpty) {
      throw StateError('Missing dart-define(s): ${missing.join(', ')}');
    }
  }
}
