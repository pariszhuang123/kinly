// lib/foundation/surfaces/hub/hub_surface.dart
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/router/app_route_names.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_bottom_sheet.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/kinly_scrollbar.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/kinly_refresh_indicator.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../generated/l10n.dart';
import 'bloc/hub_bloc.dart';
import 'hub_registry.dart';
import 'hub_slots.dart';
import 'widget/hub_qr_section.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    HubRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    return PopScope(
      canPop: false,
      child: KinlyScaffold(
        backgroundColor: colorScheme.surface,
        appBar: KinlyAppBar(
          backgroundColor: colorScheme.surface,
          title: Text(s.navHub),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = sizes?.maxContentWidth ?? 640.0;
              final width =
                  constraints.maxWidth < maxWidth
                      ? constraints.maxWidth
                      : maxWidth;

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(spacing.lg),
                    child: BlocConsumer<HubBloc, HubState>(
                      listenWhen:
                          (previous, current) =>
                              previous.notice != current.notice &&
                              current.notice != null &&
                              !current.isFailure,
                      listener: (context, state) {
                        if (!context.mounted) return;
                        switch (state.notice) {
                          case HubNotice.rotateSuccess:
                            KinlySnackBar.showSuccess(
                              context,
                              s.hubRotateSuccess,
                            );
                            return;
                          case HubNotice.rotateFailed:
                            KinlySnackBar.showError(context, s.hubRotateError);
                            return;
                          case HubNotice.refreshFailed:
                            KinlySnackBar.showError(context, s.hubError);
                            return;
                          case HubNotice.loadFailed:
                          case null:
                            return;
                        }
                      },
                      builder: (context, state) {
                        return _buildHubContent(
                          context: context,
                          state: state,
                          spacing: spacing,
                          sections: sections,
                          strings: s,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: HomeBottomNav(
          currentIndex: 2,
          onTap: (index) {
            switch (index) {
              case 0:
                context.goNamed(AppRouteNames.today);
                break;
              case 1:
                context.goNamed(AppRouteNames.explore);
                break;
              case 2:
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildHubContent({
    required BuildContext context,
    required HubState state,
    required Spacing spacing,
    required KinlySections sections,
    required S strings,
  }) {
    if (state.isLoading && !state.isRefreshing) {
      return const Center(child: KinlyLoader());
    }
    if (state.isFailure) {
      return _HubError(
        onRetry: () => context.read<HubBloc>().add(const HubRefreshed()),
      );
    }
    final actions = HubSurfaceActions(
      onInviteTap: () => _shareInvite(context, state),
      onShareAppTap: () => _shareAppLink(context, state),
      onQrTap: () => _showQrSheet(context, state),
      onGratitudeTap: () => context.pushNamed(AppRouteNames.gratitudeWall),
      onCopyCode:
          state.hasInvite ? () => _copyInviteCode(context, state) : null,
      onRotateInvite: state.isOwner ? () => _rotateInvite(context) : null,
    );
    final scope = HubSurfaceScope(
      context: context,
      state: state,
      spacing: spacing,
      sections: sections,
      strings: strings,
      actions: actions,
      homeId: homeId,
    );

    final slots = HubSurfaceSlots(body: _buildHubBody(scope));
    return slots.body;
  }

  Widget _buildHubBody(HubSurfaceScope scope) {
    final controller = ScrollController();
    return KinlyRefreshIndicator(
      onRefresh:
          () async => scope.context.read<HubBloc>().add(const HubRefreshed()),
      child: KinlyScrollbar(
        controller: controller,
        child: KinlyScrollFade(
          child: SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildHubSections(scope),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHubSections(HubSurfaceScope scope) {
    final entries = HubRegistry.bodySections;
    final spacing = scope.spacing;
    final children = <Widget>[SizedBox(height: spacing.lg)];

    for (final entry in entries) {
      if (entry.isVisible != null && !entry.isVisible!(scope)) {
        continue;
      }
      children.add(entry.builder(scope));
      final gap = _resolveSectionSpacing(entry.spacingAfter, spacing);
      if (gap > 0) {
        children.add(SizedBox(height: gap));
      }
    }
    children.add(SizedBox(height: spacing.xl));

    return children;
  }

  double _resolveSectionSpacing(HubSectionSpacing spacing, Spacing tokens) {
    switch (spacing) {
      case HubSectionSpacing.none:
        return 0;
      case HubSectionSpacing.sm:
        return tokens.sm;
      case HubSectionSpacing.md:
        return tokens.md;
      case HubSectionSpacing.lg:
        return tokens.lg;
      case HubSectionSpacing.xl:
        return tokens.xl;
    }
  }

  Future<void> _shareInvite(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (!state.hasInvite) {
      KinlySnackBar.showError(context, s.hubInviteUnavailable);
      context.read<HubBloc>().add(const HubRefreshed());
      return;
    }

    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';
    final raw = s.hubShareInviteBody(state.inviteCode, appLink);
    final message = raw.replaceAll(r'\n', '\n');

    context.read<HubBloc>().add(
      const HubShareLogged(
        feature: 'invite_housemate',
        channel: 'system_share',
      ),
    );

    await Share.share(message, subject: s.hubShareInviteTitle);
  }

  Future<void> _shareAppLink(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (state.appLink.isEmpty) {
      KinlySnackBar.showError(context, s.hubInviteUnavailable);
      return;
    }

    final raw = s.hubShareAppBody(state.appLink);
    final message = raw.replaceAll(r'\n', '\n');

    context.read<HubBloc>().add(
      const HubShareLogged(feature: 'invite_button', channel: 'system_share'),
    );

    await Share.share(message, subject: s.hubShareAppTitle);
  }

  Future<void> _copyInviteCode(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (!state.hasInvite || state.inviteCode.isEmpty) {
      KinlySnackBar.showError(context, s.hubInviteUnavailable);
      return;
    }

    context.read<HubBloc>().add(
      const HubShareLogged(feature: 'invite_button', channel: 'system_share'),
    );

    await Clipboard.setData(ClipboardData(text: state.inviteCode));
    if (!context.mounted) return;
    KinlySnackBar.showSuccess(context, s.hubCodeCopied);
  }

  Future<void> _rotateInvite(BuildContext context) async {
    context.read<HubBloc>().add(const HubInviteRotated());
  }

  void _showQrSheet(BuildContext context, HubState state) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';

    context.read<HubBloc>().add(
      const HubShareLogged(feature: 'invite_button', channel: 'qr_code'),
    );

    KinlyBottomSheet.show<void>(
      context: context,
      title: s.hubQrTitle,
      subtitle: s.hubQrSubtitle,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: HubQrCode(
              data: appLink,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _HubError extends StatelessWidget {
  const _HubError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(KinlyIcons.errorOutline, color: colorScheme.error),
          const SizedBox(height: 8),
          Text(s.hubError, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          KinlyFilledButton.text(onPressed: onRetry, label: s.hubRetry),
        ],
      ),
    );
  }
}
