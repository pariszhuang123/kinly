import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/app_config.dart';
import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/router/go_router_refresh_stream.dart';
import 'core/supabase/supabase_init.dart';
import 'core/theme/kinly_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/home_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  AppConfig.validate();
  await initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final GoRouterRefreshStream _routerRefresh;
  late final RouterConfig<Object> _router;

  @override
  void initState() {
    super.initState();
    final authRepo = sl<AuthRepository>();
    final homeRepo = sl<HomeRepository>();
    _authBloc = AuthBloc(authRepository: authRepo, homeRepository: homeRepo);
    _routerRefresh = GoRouterRefreshStream(_authBloc.stream);
    _router = createRouter(
      authBloc: _authBloc,
      refreshListenable: _routerRefresh,
    );
  }

  @override
  void dispose() {
    _routerRefresh.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        onGenerateTitle: (context) => S.of(context).app_title,
        routerConfig: _router,
        // Show a simple fallback while the router builds to avoid a black screen
        builder: (context, child) {
          if (child != null) return child;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Starting Kinly (${AppConfig.env})'),
                ],
              ),
            ),
          );
        },
        theme: buildKinlyTheme(Brightness.light),
        darkTheme: buildKinlyTheme(Brightness.dark),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
