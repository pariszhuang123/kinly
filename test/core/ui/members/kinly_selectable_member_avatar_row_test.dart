import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/ui/members/kinly_selectable_member_avatar_row.dart';

HomeMemberSummary _member(String id, String name) {
  return HomeMemberSummary(
    userId: id,
    username: name,
    role: 'member',
    validFrom: DateTime(2024, 1, 1),
    avatarUrl: null,
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      extensions: const <ThemeExtension<dynamic>>[KinlyOpacity.defaults],
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('taps call onToggle with member id', (tester) async {
    String? toggled;
    await tester.pumpWidget(
      _wrap(
        KinlySelectableMemberAvatarRow(
          members: [_member('user-1', 'Alice'), _member('user-2', 'Bob')],
          selectedMemberIds: const {},
          onToggle: (id) => toggled = id,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('selectable-member-user-1')));
    await tester.pumpAndSettle();

    expect(toggled, 'user-1');
  });

  testWidgets('semantics reflect selected state', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableMemberAvatarRow(
          members: [_member('user-1', 'Alice')],
          selectedMemberIds: const {'user-1'},
          onToggle: (_) {},
        ),
      ),
    );

    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('selectable-member-user-1')),
    );
    final data = semantics.getSemanticsData();
    expect(data.flagsCollection.isSelected.toBoolOrNull(), isTrue);
  });

  testWidgets('empty selection renders without selected styling', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableMemberAvatarRow(
          members: [_member('user-1', 'Alice')],
          selectedMemberIds: const {},
          onToggle: (_) {},
        ),
      ),
    );

    final scaleWidget = tester.widget<AnimatedScale>(
      find.byType(AnimatedScale).first,
    );
    expect(scaleWidget.scale, 1.0);

    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('selectable-member-user-1')),
    );
    final data = semantics.getSemanticsData();
    expect(data.flagsCollection.isSelected.toBoolOrNull(), isFalse);
  });

  testWidgets('names stay hidden when unselected', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableMemberAvatarRow(
          members: [_member('user-1', 'Alice')],
          selectedMemberIds: const {},
          onToggle: (_) {},
        ),
      ),
    );

    expect(find.text('Alice'), findsNothing);
  });

  testWidgets('names appear when selected', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableMemberAvatarRow(
          members: [_member('user-1', 'Alice')],
          selectedMemberIds: const {'user-1'},
          onToggle: (_) {},
        ),
      ),
    );

    expect(find.text('Alice'), findsOneWidget);
  });
}
