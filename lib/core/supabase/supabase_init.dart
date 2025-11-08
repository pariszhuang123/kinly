import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: AppConfig.env == 'dev',
    authOptions: const FlutterAuthClientOptions(
      // PKCE is recommended for mobile
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

