import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/house_norms/ui/house_norm_report_provider.dart';
import 'package:kinly/generated/l10n.dart';

class _NoopHouseNormsRepository implements HouseNormsRepository {
  @override
  Future<HouseNormDocument?> getForHome({
    required String homeId,
    required String locale,
  }) async => null;

  @override
  Future<HouseNormDocument> generateForHome({
    required String homeId,
    String templateKey = 'house_norms_v1',
    required String locale,
    required Map<String, int> inputs,
    bool force = false,
  }) async => _buildDocument();

  @override
  Future<HouseNormDocument> editSectionText({
    required String homeId,
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async => _buildDocument();

  @override
  Future<HouseNormDocument> publishForHome({
    required String homeId,
    required String locale,
  }) async => _buildDocument();

  @override
  Future<void> recordView({required String homeId}) async {}
}

void main() {
  Widget buildApp({
    required bool isOwner,
    required HouseNormDocument document,
  }) {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: HouseNormReportProvider(
        homeId: 'home-1',
        locale: 'en',
        isOwner: isOwner,
        repository: _NoopHouseNormsRepository(),
        initialDocument: document,
        showDoneCta: false,
      ),
    );
  }

  Widget buildRouterApp({
    required String initialLocation,
    required String backRouteName,
  }) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/report',
          name: AppRouteNames.houseNormsReport,
          builder:
              (_, __) => HouseNormReportProvider(
                homeId: 'home-1',
                locale: 'en',
                isOwner: false,
                repository: _NoopHouseNormsRepository(),
                initialDocument: _buildDocument(),
                showDoneCta: false,
                backRouteName: backRouteName,
              ),
        ),
        GoRoute(
          path: '/today',
          name: AppRouteNames.today,
          builder: (_, __) => const Scaffold(body: Text('Today')),
        ),
        GoRoute(
          path: '/hub',
          name: AppRouteNames.hub,
          builder: (_, __) => const Scaffold(body: Text('Hub')),
        ),
      ],
    );
    addTearDown(router.dispose);

    return MaterialApp.router(
      routerConfig: router,
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  testWidgets(
    'owner sees public url and edit controls when out_of_date',
    (tester) async {
    await tester.pumpWidget(
      buildApp(
        isOwner: true,
        document: _buildDocument(
          status: 'out_of_date',
          showRepublishButton: true,
          showPublicUrl: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final strings = S.of(tester.element(find.byType(HouseNormReportProvider)));

    expect(find.text(strings.houseNormRepublishCta), findsOneWidget);
    expect(find.text(strings.houseNormCopyUrlCta), findsOneWidget);
    expect(find.text(strings.houseNormEditTitle), findsOneWidget);
  });

  testWidgets('non-owner does not see owner controls', (tester) async {
    await tester.pumpWidget(
      buildApp(
        isOwner: false,
        document: _buildDocument(
          status: 'published',
          showRepublishButton: false,
          showPublicUrl: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final strings = S.of(tester.element(find.byType(HouseNormReportProvider)));

    expect(find.text(strings.houseNormRepublishCta), findsNothing);
    expect(find.text(strings.houseNormPublishCta), findsNothing);
    expect(find.text(strings.houseNormCopyUrlCta), findsNothing);
    expect(find.text(strings.houseNormEditTitle), findsNothing);
  });

  testWidgets(
    'back button routes to Today when no stack and back target is Today',
    (tester) async {
      await tester.pumpWidget(
        buildRouterApp(
          initialLocation: '/report',
          backRouteName: AppRouteNames.today,
        ),
      );
      await tester.pumpAndSettle();

      final strings = S.of(tester.element(find.byType(HouseNormReportProvider)));
      await tester.tap(find.bySemanticsLabel(strings.houseNormOnboardingBack));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
    },
  );

  testWidgets(
    'back button routes to Hub when no stack and back target is Hub',
    (tester) async {
      await tester.pumpWidget(
        buildRouterApp(
          initialLocation: '/report',
          backRouteName: AppRouteNames.hub,
        ),
      );
      await tester.pumpAndSettle();

      final strings = S.of(tester.element(find.byType(HouseNormReportProvider)));
      await tester.tap(find.bySemanticsLabel(strings.houseNormOnboardingBack));
      await tester.pumpAndSettle();

      expect(find.text('Hub'), findsOneWidget);
    },
  );

  testWidgets(
    'system back routes to Hub when no stack and back target is Hub',
    (tester) async {
      await tester.pumpWidget(
        buildRouterApp(
          initialLocation: '/report',
          backRouteName: AppRouteNames.hub,
        ),
      );
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Hub'), findsOneWidget);
    },
  );
}

HouseNormDocument _buildDocument({
  String status = 'published',
  bool showRepublishButton = false,
  bool showPublicUrl = true,
}) {
  return HouseNormDocument(
    homeId: 'home-1',
    templateKey: 'house_norms_v1',
    status: status,
    inputs: const {},
    draftContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'A shared starting point.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'We usually wind down.',
        ),
      ],
    ),
    draftUpdatedAt: DateTime.utc(2026, 1, 1),
    publishedContent: const HouseNormContent(
      summary: HouseNormSummary(
        title: 'House norms',
        subtitle: 'Shared defaults',
        framing: 'Published framing.',
      ),
      context: 'Context',
      sections: [
        HouseNormSection(
          sectionKey: 'norms_rhythm_quiet',
          title: 'Rhythm',
          text: 'Published text.',
        ),
      ],
    ),
    publishedAt: DateTime.utc(2026, 1, 1),
    publishedVersion: 'v1',
    isPublished: true,
    hasUnpublishedChanges: status == 'out_of_date',
    lastEditedAt: null,
    lastEditedBy: null,
    homePublicId: 'home_public_1',
    publicUrl: 'https://go.makinglifeeasie.com/norms/home_public_1',
    showPublishButton: false,
    showRepublishButton: showRepublishButton,
    showPublicUrl: showPublicUrl,
    memberViewedAt: null,
    showMemberReviewCard: false,
  );
}
