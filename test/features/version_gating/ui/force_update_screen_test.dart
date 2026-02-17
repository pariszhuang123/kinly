import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:kinly/core/config/app_config.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/version_gating/ui/force_update_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _FakeUrlLauncherPlatform extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  String? launchedUrl;
  LaunchOptions? launchOptions;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchOptions = options;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UrlLauncherPlatform previousLauncher;
  late _FakeUrlLauncherPlatform fakeLauncher;

  setUp(() {
    previousLauncher = UrlLauncherPlatform.instance;
    fakeLauncher = _FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakeLauncher;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = previousLauncher;
  });

  testWidgets('launches centralized public app link', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const ForceUpdateScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ForceUpdateScreen));
    final strings = S.of(context);
    await tester.tap(find.text(strings.force_update_button));
    await tester.pumpAndSettle();

    expect(fakeLauncher.launchedUrl, resolveKinlyPublicAppLink());
    expect(
      fakeLauncher.launchOptions?.mode,
      PreferredLaunchMode.externalApplication,
    );
  });
}
