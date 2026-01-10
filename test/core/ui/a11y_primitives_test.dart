import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/buttons/kinly_add_tile_button.dart';
import 'package:kinly/core/ui/buttons/kinly_option_selector_row.dart';
import 'package:kinly/core/ui/badges/kinly_badge.dart';
import 'package:kinly/core/ui/kinly_selection_card.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/members/kinly_member_avatar_chip.dart';
import 'package:kinly/core/ui/media/kinly_photo_capture.dart';
import 'package:kinly/core/ui/profile/kinly_profile_header.dart';
import 'package:kinly/core/ui/toggles/kinly_toggle.dart';
import 'package:kinly/core/theme/kinly_sections.dart';

Widget _wrap(Widget child, {double textScale = 2.0}) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('KinlyFilledButton enforces 48dp min size and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyFilledButton.text(
          onPressed: () {},
          label: 'Tap me',
          semanticsLabel: 'Do action',
        ),
      ),
    );

    final size = tester.getSize(find.byType(KinlyFilledButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(find.bySemanticsLabel('Do action'), findsOneWidget);
  });

  testWidgets('KinlyOutlinedButton enforces 48dp min size and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyOutlinedButton.text(
          onPressed: () {},
          label: 'Outline',
          semanticsLabel: 'Outline button',
        ),
      ),
    );

    final size = tester.getSize(find.byType(KinlyOutlinedButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(find.bySemanticsLabel('Outline button'), findsOneWidget);
  });

  testWidgets('KinlyListTile enforces 48dp min size and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyListTile(title: 'List item', subtitle: 'Details', onTap: () {}),
      ),
    );

    final size = tester.getSize(find.byType(KinlyListTile));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(find.bySemanticsLabel('List item, Details'), findsOneWidget);
  });

  testWidgets('KinlyBadge exposes semantics label', (tester) async {
    await tester.pumpWidget(_wrap(const KinlyBadge(label: 'New')));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('New'), findsOneWidget);
  });

  testWidgets('KinlyBadge uses explicit semantics label when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const KinlyBadge(label: 'new today', semanticsLabel: 'New items today'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('New items today'), findsOneWidget);
  });

  testWidgets('KinlyToggle enforces 48dp min size and semantics', (
    tester,
  ) async {
    var toggled = false;
    await tester.pumpWidget(
      _wrap(
        KinlyToggle(
          value: toggled,
          onChanged: (v) => toggled = v,
          title: 'Toggle me',
          semanticsLabel: 'Toggle semantics',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyToggle));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Toggle semantics',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlyAddTileButton enforces 48dp min size and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyAddTileButton(
          onTap: () {},
          label: 'Add item',
          semanticsLabel: 'Add tile',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyAddTileButton));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Add tile',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlyOptionSelectorRow enforces semantics and size', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyOptionSelectorRow<String>(
          options: const [
            KinlySelectorOption(value: 'a', label: 'Option A'),
            KinlySelectorOption(value: 'b', label: 'Option B'),
          ],
          selectedValue: 'a',
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyOptionSelectorRow<String>));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Option A',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlyMemberAvatarChip enforces touch target and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyMemberAvatarChip(
          displayName: 'Alex Doe',
          avatarUrl: null,
          onTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyMemberAvatarChip));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Alex Doe',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlySelectionCard enforces touch target and semantics', (
    tester,
  ) async {
    const colors = SectionColors(
      background: Colors.white,
      card: Colors.white,
      icon: Colors.black,
      accent: Colors.black,
    );
    await tester.pumpWidget(
      _wrap(
        KinlySelectionCard(
          colors: colors,
          title: 'Selection',
          subtitle: 'Details',
          icon: const Icon(Icons.star),
          onTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlySelectionCard));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Selection, Details',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlyPhotoCapture enforces touch target and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 400,
          height: 700,
          child: KinlyPhotoCapture(
            label: 'Add photo',
            placeholderText: 'Placeholder',
            onTap: () {},
            aspectRatio: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyPhotoCapture));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Add photo',
      ),
      findsOneWidget,
    );
  });

  testWidgets('KinlyProfileHeader enforces touch target and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlyProfileHeader(
          displayName: 'Casey',
          subtitle: 'Owner',
          onAvatarTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(KinlyProfileHeader));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Casey',
      ),
      findsOneWidget,
    );
  });
}
