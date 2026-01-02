import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/share/models.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_expectation_photo_viewer.dart';
import 'package:kinly/features/paywall/ui/paywall_route_args.dart';
import 'package:kinly/features/share/ui/share_detail_route_args.dart';
import 'package:kinly/features/share/ui/share_navigation.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';

void main() {
  testWidgets('pushNamed passes flow chore photo args', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouteNames.flowChorePhoto,
                        extra: const FlowChorePhotoViewerArgs(
                          photoUrl: 'https://example.com/photo.jpg',
                          heroTag: 'hero',
                          title: 'Photo',
                        ),
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              ),
        ),
        GoRoute(
          path: '/flow/chore/photo',
          name: AppRouteNames.flowChorePhoto,
          builder: (_, state) {
            final args = state.extra as FlowChorePhotoViewerArgs;
            return Scaffold(body: Text('photo:${args.photoUrl}'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('photo:https://example.com/photo.jpg'), findsOneWidget);
  });

  testWidgets('ShareNavigationImpl uses named route for owed detail', (
    tester,
  ) async {
    final owed = TodayShareOwed(
      payerUserId: 'payer-1',
      displayName: 'Payer',
      totalOwedCents: 1200,
      items: [
        TodayShareOwedItem(
          expenseId: 'expense-1',
          description: 'Test',
          amountCents: 1200,
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
        ),
      ],
    );

    final navigation = const ShareNavigationImpl();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed:
                        () => navigation.openOwedDetail(
                          context: context,
                          owed: owed,
                        ),
                    child: const Text('open-owed'),
                  ),
                ),
              ),
        ),
        GoRoute(
          path: '/share/owed-detail',
          name: AppRouteNames.shareOwedDetail,
          builder: (_, state) {
            final args = state.extra as ShareOwedDetailRouteArgs;
            return Scaffold(body: Text('owed:${args.owed.payerUserId}'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open-owed'));
    await tester.pumpAndSettle();

    expect(find.text('owed:payer-1'), findsOneWidget);
  });

  testWidgets('pushNamed passes paywall args', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRouteNames.paywall,
                        extra: PaywallRouteArgs(
                          homeId: 'home-1',
                          strings: PaywallStrings(
                            title: 'Title',
                            subtitle: 'Subtitle',
                            bulletMembers: 'Members',
                            bulletFlows: 'Flows',
                            bulletPhotos: 'Photos',
                            bulletShares: 'Shares',
                            unlimitedLabel: 'Unlimited',
                            priceCaption: 'Price',
                            priceUnavailableLabel: 'Unavailable',
                            priceFormatter: (price) => price,
                            primaryCta: 'Primary',
                            secondaryCta: 'Secondary',
                            purchaseFailed: 'Failed',
                            purchaseSuccess: 'Success',
                            restoreCta: 'Restore',
                            errorTitle: 'Error',
                            retryLabel: 'Retry',
                          ),
                        ),
                      );
                    },
                    child: const Text('open-paywall'),
                  ),
                ),
              ),
        ),
        GoRoute(
          path: '/paywall',
          name: AppRouteNames.paywall,
          builder: (_, state) {
            final args = state.extra as PaywallRouteArgs;
            return Scaffold(body: Text('paywall:${args.homeId}'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open-paywall'));
    await tester.pumpAndSettle();

    expect(find.text('paywall:home-1'), findsOneWidget);
  });

  testWidgets('pushNamed navigates to info hub', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppRouteNames.infoHub);
                    },
                    child: const Text('open-info-hub'),
                  ),
                ),
              ),
        ),
        GoRoute(
          path: '/settings/profile/info-hub',
          name: AppRouteNames.infoHub,
          builder: (_, __) => const Scaffold(body: Text('info-hub')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open-info-hub'));
    await tester.pumpAndSettle();

    expect(find.text('info-hub'), findsOneWidget);
  });
}
