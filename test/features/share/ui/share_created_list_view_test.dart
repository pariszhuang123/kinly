import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/features/share/bloc/share_created_list_bloc/share_created_list_bloc.dart';
import 'package:kinly/features/share/ui/widgets/share_created_list_view.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShareCreatedListView', () {
    testWidgets('shows empty state with copy and CTA', (tester) async {
      var tappedCreate = false;
      const shareColors = SectionColors(
        background: Colors.white,
        card: Colors.white,
        icon: Colors.blueGrey,
        accent: Colors.orange,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData.light().copyWith(
            extensions: const [
              Spacing(
                xxs: 2,
                xs: 4,
                s: 8,
                m: 12,
                l: 16,
                xl: 24,
                xxl: 32,
                xxxl: 40,
              ),
              KinlyOpacity.defaults,
              KinlySections(
                flow: shareColors,
                share: shareColors,
                pulse: shareColors,
                empty: shareColors,
              ),
            ],
          ),
          home: Scaffold(
            body: ShareCreatedListView(
              state: const ShareCreatedListState(
                status: ShareCreatedListStatus.success,
                entries: [],
              ),
              shareColors: shareColors,
              onRefreshRequested: () async {},
              onCreateTap: () => tappedCreate = true,
              onEntryTap: (_) {},
            ),
          ),
        ),
      );

      final s = await S.delegate.load(const Locale('en'));
      expect(find.text(s.shareCreatedListEmptyTitle), findsOneWidget);
      expect(find.text(s.shareCreatedListEmptySubtitle), findsOneWidget);
      expect(find.text(s.shareCreateSubmit), findsOneWidget);

      await tester.tap(find.text(s.shareCreateSubmit));
      await tester.pump();

      expect(tappedCreate, isTrue);
    });
  });
}
