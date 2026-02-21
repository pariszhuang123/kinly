import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_flow_section/today_flow_section.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fakeSvg = _FakeSvgAssetBundle();

  testWidgets('shows only active tab when only active tasks exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: fakeSvg,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: buildKinlyTheme(Brightness.light),
          home: Scaffold(
            body: TodayFlowSection(
              activeTasks: const [
                TodayFlowTask(
                  id: 'task-1',
                  title: 'Take out trash',
                  state: ChoreState.active,
                ),
              ],
              draftTasks: const [],
              onTaskTap: (_) {},
              onSeeAllTap: (_) {},
            ),
          ),
        ),
      ),
    );

    final l10n = S.of(tester.element(find.byType(TodayFlowSection)));
    expect(find.text(l10n.todayFlowTabActive), findsOneWidget);
    expect(find.text(l10n.todayFlowTabDrafts), findsNothing);
  });

  testWidgets('shows only drafts tab when only draft tasks exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: fakeSvg,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: buildKinlyTheme(Brightness.light),
          home: Scaffold(
            body: TodayFlowSection(
              activeTasks: const [],
              draftTasks: const [
                TodayFlowTask(
                  id: 'task-1',
                  title: 'Plan recycling',
                  state: ChoreState.draft,
                ),
              ],
              onTaskTap: (_) {},
              onSeeAllTap: (_) {},
            ),
          ),
        ),
      ),
    );

    final l10n = S.of(tester.element(find.byType(TodayFlowSection)));
    expect(find.text(l10n.todayFlowTabActive), findsNothing);
    expect(find.text(l10n.todayFlowTabDrafts), findsOneWidget);
  });
}

class _FakeSvgAssetBundle extends CachingAssetBundle {
  static const _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><path d="M0 0h1v1H0z"/></svg>';

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(_svg.codeUnits);
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => _svg;
}
