import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../core/ui/kinly_selection_card.dart';
import 'bloc/hub_bloc.dart';
import 'hub_slots.dart';
import 'widget/hub_member_section.dart';
import 'widget/hub_qr_section.dart';
import 'widget/hub_preferences_section.dart';

typedef HubSectionBuilder = Widget Function(HubSurfaceScope scope);

enum HubSectionSpacing { none, sm, md, lg, xl }

class HubSectionEntry {
  const HubSectionEntry({
    required this.id,
    required this.order,
    required this.builder,
    this.spacingAfter = HubSectionSpacing.lg,
    this.isVisible,
  });

  final String id;
  final int order;
  final HubSectionBuilder builder;
  final HubSectionSpacing spacingAfter;
  final bool Function(HubSurfaceScope scope)? isVisible;
}

class HubRegistry {
  static final List<HubSectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<HubSectionEntry> get bodySections => List.unmodifiable(_entries);

  static void register(HubSectionEntry entry) {
    _entries.add(entry);
    _entries.sort((a, b) => a.order.compareTo(b.order));
  }

  static void bootstrap() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    _registerDefaults();
  }

  static void clearForTest() {
    _entries.clear();
    _bootstrapped = false;
  }

  static void _registerDefaults() {
    register(
      HubSectionEntry(
        id: 'members',
        order: 10,
        spacingAfter: HubSectionSpacing.none,
        builder:
            (scope) => HubMembersSection(
              state: scope.state,
              onInviteTap: scope.actions.onInviteTap,
              onCopyCode: scope.actions.onCopyCode,
              onRotateInvite: scope.actions.onRotateInvite,
            ),
      ),
    );

    register(
      HubSectionEntry(
        id: 'qr',
        order: 20,
        spacingAfter: HubSectionSpacing.xl,
        builder:
            (scope) => HubQrSection(
              state: scope.state,
              onShareAppTap: scope.actions.onShareAppTap,
              onQrTap: scope.actions.onQrTap,
            ),
      ),
    );

    register(
      HubSectionEntry(
        id: 'preferences',
        order: 27,
        spacingAfter: HubSectionSpacing.lg,
        isVisible: (scope) => scope.state.hasPreferenceReports,
        builder:
            (scope) => HubPreferencesSection(
              members: scope.state.members,
              reportItems: scope.state.preferenceReports,
              currentUserId: scope.state.currentUserId,
              houseVibe: scope.state.houseVibe,
              hubBloc: scope.context.read<HubBloc>(),
            ),
      ),
    );

    register(
      HubSectionEntry(
        id: 'house_norms',
        order: 25,
        spacingAfter: HubSectionSpacing.lg,
        isVisible: (scope) => scope.state.hasHouseNorms,
        builder: (scope) {
          final palette = scope.sections.houseNorms;
          return KinlySelectionCard(
            colors: palette,
            title: scope.strings.hubHouseNormsTitle,
            subtitle: scope.strings.hubHouseNormsSubtitle,
            icon: Icon(
              KinlyIcons.notesOutlined,
              color: palette.icon,
              size: 28,
            ),
            onTap: scope.actions.onHouseNormsTap,
          );
        },
      ),
    );

    register(
      HubSectionEntry(
        id: 'gratitude',
        order: 30,
        spacingAfter: HubSectionSpacing.lg,
        builder: (scope) {
          return KinlySelectionCard(
            colors: scope.sections.pulse,
            title: scope.strings.hubCardGratitudeWallTitle,
            subtitle: scope.strings.hubCardGratitudeWallSubtitle,
            icon: Icon(
              KinlyIcons.favoriteRounded,
              color: scope.sections.pulse.icon,
              size: 28,
            ),
            onTap: scope.actions.onGratitudeTap,
          );
        },
      ),
    );
  }
}
