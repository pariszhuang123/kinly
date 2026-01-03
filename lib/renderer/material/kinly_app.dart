import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../generated/l10n.dart';
import 'theme/kinly_theme.dart';

class KinlyApp extends StatelessWidget {
  const KinlyApp({
    super.key,
    required this.routerConfig,
    this.builder,
  });

  final RouterConfig<Object> routerConfig;
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => S.of(context).app_title,
      routerConfig: routerConfig,
      builder: builder,
      theme: buildKinlyTheme(Brightness.light),
      darkTheme: buildKinlyTheme(Brightness.dark),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
