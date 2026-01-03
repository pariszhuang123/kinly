import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/flow/routes/flow_routes.dart';

void main() {
  test('flow chore photo route is declared before the edit route', () {
    final routes = buildFlowRoutes(
      resolveContext: () => const FlowRouteContext(
        homeId: 'home-1',
        userId: 'user-1',
      ),
    );

    final paths =
        routes
            .whereType<GoRoute>()
            .map((route) => route.path)
            .toList(growable: false);

    final photoIndex = paths.indexOf(AppRoutePaths.flowChorePhoto);
    final editIndex = paths.indexOf(AppRoutePaths.flowChoreEdit);

    expect(photoIndex, isNot(equals(-1)));
    expect(editIndex, isNot(equals(-1)));
    expect(
      photoIndex,
      lessThan(editIndex),
      reason:
          'Static photo path must be matched before the :choreId edit route.',
    );
  });
}
