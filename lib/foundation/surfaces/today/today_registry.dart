import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'today_slots.dart';
import 'widgets/today_flow_section/today_flow_section_container.dart';
import 'widgets/today_house_pulse_card.dart';
import 'widgets/today_gratitude_section.dart';
import 'widgets/today_invite_prompt.dart';
import 'widgets/today_share_section/today_share_section_container.dart';

typedef TodaySectionBuilder = Widget Function(TodaySurfaceScope scope);

enum TodaySectionSpacing { none, sm, md, lg, xl }

class TodaySectionEntry {
  const TodaySectionEntry({
    required this.id,
    required this.order,
    required this.builder,
    this.spacingAfter = TodaySectionSpacing.lg,
    this.isVisible,
  });

  final String id;
  final int order;
  final TodaySectionBuilder builder;
  final TodaySectionSpacing spacingAfter;
  final bool Function(TodaySurfaceScope scope)? isVisible;
}

class TodayRegistry {
  static final List<TodaySectionEntry> _entries = [];
  static bool _bootstrapped = false;

  static List<TodaySectionEntry> get bodySections =>
      List.unmodifiable(_entries);

  static void register(TodaySectionEntry entry) {
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
      TodaySectionEntry(
        id: 'member_cap',
        order: 10,
        builder: _buildMemberCapPrompt,
        isVisible: _shouldShowMemberCapPrompt,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'preferences',
        order: 15,
        builder: _buildPreferencesPrompt,
        isVisible: (scope) => scope.state.shouldPromptPreferences,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'invite',
        order: 20,
        builder: _buildInvitePrompt,
        isVisible: (scope) => scope.inviteConfig.showPrompt,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'house_pulse',
        order: 25,
        spacingAfter: TodaySectionSpacing.lg,
        builder: _buildHousePulseCard,
        isVisible: (scope) => scope.state.hasHousePulseCard,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'flow',
        order: 30,
        builder:
            (scope) => TodayFlowSectionContainer(
              onTaskTap: scope.actions.onFlowTaskTap,
              onSeeAllTap: scope.actions.onFlowSeeAllTap,
            ),
        isVisible: (scope) => scope.state.hasFlowContent,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'share',
        order: 40,
        spacingAfter: TodaySectionSpacing.lg,
        builder:
            (scope) => TodayShareSectionContainer(
              onOwedTap: scope.actions.onShareOwedTap,
              onPaidToMeTap: scope.actions.onSharePaidToMeTap,
              onDraftTap: scope.actions.onShareDraftTap,
              onSeeAllDraftsTap: scope.actions.onShareSeeAllDraftsTap,
            ),
        isVisible: (scope) => scope.state.hasShareContent,
      ),
    );

    register(
      TodaySectionEntry(
        id: 'gratitude',
        order: 50,
        spacingAfter: TodaySectionSpacing.none,
        builder:
            (scope) => TodayGratitudeSection(
              onHouseTap: scope.actions.onGratitudeTap,
              onPersonalTap: scope.actions.onPersonalGratitudeTap,
              showPersonal: scope.state.personalGratitudeStatus != null,
              personalHasUnread: scope.state.hasPersonalGratitudeUnread,
            ),
        isVisible:
            (scope) =>
                scope.state.hasGratitudeUnread ||
                scope.state.hasPersonalGratitudeUnread,
      ),
    );
  }
}

bool _shouldShowMemberCapPrompt(TodaySurfaceScope scope) {
  final memberCap = scope.state.memberCapJoinRequests;
  return (memberCap?.pendingCount ?? 0) > 0 &&
      scope.state.profile?.isOwner == true;
}

Widget _buildMemberCapPrompt(TodaySurfaceScope scope) {
  final memberCap = scope.state.memberCapJoinRequests;
  final memberCapNames = memberCap?.joinerNames ?? const <String>[];
  final memberCapNamesLabel = scope.formatMemberCapNames(memberCapNames);
  final subtitle =
      memberCapNamesLabel.isNotEmpty
          ? scope.strings.todayMemberCapSubtitle(memberCapNamesLabel)
          : scope.strings.todayMemberCapSubtitleGeneric;

  return TodayInvitePrompt(
    title: scope.strings.todayMemberCapTitle,
    subtitle: subtitle,
    primaryLabel: scope.strings.todayMemberCapPrimaryCta,
    secondaryLabel: scope.strings.todayMemberCapSecondaryCta,
    onPrimary: () => scope.actions.onMemberCapPrimary(),
    onSecondary: scope.actions.onMemberCapSecondary,
  );
}

Widget _buildInvitePrompt(TodaySurfaceScope scope) {
  final config = scope.inviteConfig;
  final title =
      config.isFlatmate
          ? scope.strings.todayFlatmateInviteTitle
          : scope.strings.todayInviteFriendsTitle;
  final subtitle =
      config.isFlatmate
          ? scope.strings.todayFlatmateInviteSubtitle
          : scope.strings.todayInviteFriendsSubtitle;

  return TodayInvitePrompt(
    title: title,
    subtitle: subtitle,
    primaryLabel: scope.strings.todayInviteShareCta,
    secondaryLabel: scope.strings.todayInviteNotNow,
    onPrimary: () => scope.actions.onInvitePrimary(config),
    onSecondary: config.isFlatmate ? scope.actions.onInviteSecondary : null,
  );
}

Widget _buildPreferencesPrompt(TodaySurfaceScope scope) {
  final palette = scope.context.preferenceSection;
  return TodayInvitePrompt(
    title: scope.strings.preferencePromptTitle,
    subtitle: scope.strings.preferencePromptSubtitle,
    primaryLabel: scope.strings.preferencePromptCta,
    onPrimary: scope.actions.onPreferencePrompt,
    palette: palette,
  );
}

Widget _buildHousePulseCard(TodaySurfaceScope scope) {
  final colors = scope.sections.pulse;
  final pulse = scope.state.housePulse;
  if (pulse == null) return const SizedBox.shrink();
  return TodayHousePulseCard(
    pulse: pulse,
    palette: colors,
    onTap: scope.actions.onHousePulseTap,
  );
}
