import 'package:flutter/widgets.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import 'bloc/today_bloc.dart';
import 'domain/models.dart';
import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';
import 'package:kinly/contracts/house_directory/models.dart';

class TodaySurfaceSlots {
  const TodaySurfaceSlots({
    this.header,
    required this.body,
    this.empty,
    this.footer,
    this.actions,
  });

  final Widget? header;
  final Widget body;
  final Widget? empty;
  final Widget? footer;
  final List<Widget>? actions;
}

class TodayInviteConfig {
  const TodayInviteConfig({
    required this.showPrompt,
    required this.isFlatmate,
    required this.logEvent,
  });

  final bool showPrompt;
  final bool isFlatmate;
  final TodayEvent logEvent;
}

class TodaySurfaceActions {
  const TodaySurfaceActions({
    required this.onMemberCapPrimary,
    required this.onMemberCapSecondary,
    required this.onPreferencePrompt,
    required this.onHouseNormsPrompt,
    required this.onInvitePrimary,
    required this.onInviteSecondary,
    required this.onFlowTaskTap,
    required this.onFlowSeeAllTap,
    required this.onShareOwedTap,
    required this.onSharePaidToMeTap,
    required this.onShareDraftTap,
    required this.onShareSeeAllDraftsTap,
    required this.onGratitudeTap,
    required this.onPersonalGratitudeTap,
    required this.onHousePulseTap,
    required this.onHouseDirectoryTap,
    required this.onHouseDirectoryReminderOpen,
    required this.onShoppingTap,
    required this.onBankAccountPrompt,
  });

  final Future<void> Function() onMemberCapPrimary;
  final VoidCallback onMemberCapSecondary;
  final VoidCallback onPreferencePrompt;
  final VoidCallback onHouseNormsPrompt;
  final Future<void> Function(TodayInviteConfig invite) onInvitePrimary;
  final VoidCallback onInviteSecondary;
  final Future<void> Function(TodayFlowTask task) onFlowTaskTap;
  final void Function(FlowListFilter filter) onFlowSeeAllTap;
  final void Function(TodayShareOwed owed) onShareOwedTap;
  final void Function(TodaySharePaidToMe entry) onSharePaidToMeTap;
  final void Function(TodayShareDraft draft) onShareDraftTap;
  final void Function() onShareSeeAllDraftsTap;
  final void Function() onGratitudeTap;
  final void Function() onPersonalGratitudeTap;
  final Future<void> Function() onHousePulseTap;
  final VoidCallback onHouseDirectoryTap;
  final Future<void> Function(HouseDirectoryReminder reminder)
      onHouseDirectoryReminderOpen;
  final VoidCallback onShoppingTap;
  final VoidCallback onBankAccountPrompt;
}

class TodaySurfaceScope {
  const TodaySurfaceScope({
    required this.context,
    required this.state,
    required this.spacing,
    required this.sections,
    required this.strings,
    required this.actions,
    required this.inviteConfig,
    required this.formatMemberCapNames,
    required this.shoppingCount,
  });

  final BuildContext context;
  final TodayState state;
  final Spacing spacing;
  final KinlySections sections;
  final S strings;
  final TodaySurfaceActions actions;
  final TodayInviteConfig inviteConfig;
  final String Function(List<String> names) formatMemberCapNames;
  final int shoppingCount;
}
