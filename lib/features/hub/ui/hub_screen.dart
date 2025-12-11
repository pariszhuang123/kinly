// lib/features/hub/ui/hub_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_bottom_sheet.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_selection_card.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../generated/l10n.dart';
import '../bloc/hub_bloc.dart';
import 'widget/hub_member_section.dart';
import 'widget/hub_qr_section.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
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
                    child: BlocBuilder<HubBloc, HubState>(
                      builder: (context, state) {
                        if (state.isLoading && !state.isRefreshing) {
                          return const Center(child: KinlyLoader());
                        }

                        if (state.isFailure) {
                          return _HubError(
                            onRetry:
                                () => context.read<HubBloc>().add(
                                  const HubRefreshed(),
                                ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh:
                              () async => context.read<HubBloc>().add(
                                const HubRefreshed(),
                              ),
                          child: KinlyScrollFade(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: spacing.xl),
                                  HubMembersSection(
                                    state: state,
                                    onInviteTap:
                                        () => _shareInvite(context, state),
                                    onCopyCode:
                                        state.hasInvite
                                            ? () =>
                                                _copyInviteCode(context, state)
                                            : null,
                                    onRotateInvite:
                                        state.isOwner
                                            ? () => _rotateInvite(context)
                                            : null,
                                  ),
                                  HubQrSection(
                                    state: state,
                                    onShareAppTap:
                                        () => _shareAppLink(context, state),
                                    onQrTap: () => _showQrSheet(context, state),
                                  ),
                                  SizedBox(height: spacing.xl),
                                  KinlySelectionCard(
                                    colors: sections.pulse,
                                    title: s.hubCardGratitudeWallTitle,
                                    subtitle: s.hubCardGratitudeWallSubtitle,
                                    icon: Icon(
                                      Icons.favorite_rounded,
                                      color: sections.pulse.icon,
                                      size: 28,
                                    ),
                                    onTap:
                                        () => context.push(
                                          AppRoutes.gratitudeWall,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                context.go(AppRoutes.today);
                break;
              case 1:
                context.go(AppRoutes.explore);
                break;
              case 2:
                break;
            }
          },
        ),
      ),
    );
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
    final s = S.of(context);
    try {
      context.read<HubBloc>().add(const HubInviteRotated());
      if (!context.mounted) return;
      KinlySnackBar.showSuccess(context, s.hubRotateSuccess);
    } catch (_) {
      if (!context.mounted) return;
      KinlySnackBar.showError(context, s.hubRotateError);
    }
  }

  void _showQrSheet(BuildContext context, HubState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';
    final isDark = theme.brightness == Brightness.dark;

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
              isDark: isDark,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(height: 8),
          Text(s.hubError, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          KinlyFilledButton.text(onPressed: onRetry, label: s.hubRetry),
        ],
      ),
    );
  }
}
