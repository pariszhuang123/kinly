import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/buttons/kinly_add_tile_button.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';
import 'package:kinly/foundation/surfaces/hub/widget/hub_member_section.dart';
import 'package:kinly/generated/l10n.dart';

class _FakeSvgBundle extends CachingAssetBundle {
  static const _emptySvg = '<svg viewBox="0 0 24 24"></svg>';

  @override
  Future<ByteData> load(String key) async {
    return ByteData.view(Uint8List.fromList(_emptySvg.codeUnits).buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.endsWith('.svg')) {
      return _emptySvg;
    }
    throw FlutterError('Asset $key not mocked in tests');
  }
}

void main() {
  HubState buildStateWithMembers(List<HomeMemberSummary> members) {
    return HubState(
      status: HubStatus.success,
      members: members,
      preferenceReports: const [],
      currentUserId: 'owner-1',
      invite: HomeInvite(
        id: 'invite-1',
        homeId: 'home-1',
        code: 'JOIN123',
        createdBy: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
      ),
      inviteLink: 'https://example.com',
      appLink: 'https://example.com/app',
      isOwner: true,
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

  Widget wrap(Widget child) {
    return DefaultAssetBundle(
      bundle: _FakeSvgBundle(),
      child: MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders stacked avatars and invite tile', (tester) async {
    final state = buildStateWithMembers(buildMembers(6));
    await tester.pumpWidget(
      wrap(
        HubMembersSection(
          state: state,
          onInviteTap: () {},
          onCopyCode: () {},
          onRotateInvite: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('JOIN123'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.byType(KinlyAddTileButton), findsOneWidget);
  });
}
