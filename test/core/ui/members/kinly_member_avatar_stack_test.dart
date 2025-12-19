import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/ui/members/kinly_member_avatar_stack.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        extensions: const <ThemeExtension<dynamic>>[KinlyOpacity.defaults],
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  List<HomeMemberSummary> buildMembers(int count) {
    return List.generate(
      count,
      (i) => HomeMemberSummary(
        userId: 'user-$i',
        username: 'User $i',
        role: i == 0 ? 'owner' : 'member',
        validFrom: DateTime(2024, 1, 1),
        avatarUrl: null,
      ),
    );
  }

  testWidgets('shows no overflow badge when members <= maxVisible', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        KinlyMemberAvatarStack(
          members: buildMembers(4),
          maxVisible: 5,
          radius: 20,
        ),
      ),
    );

    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('shows overflow badge when members exceed maxVisible', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        KinlyMemberAvatarStack(
          members: buildMembers(7),
          maxVisible: 5,
          radius: 20,
        ),
      ),
    );

    expect(find.text('+2'), findsOneWidget);
  });
}
