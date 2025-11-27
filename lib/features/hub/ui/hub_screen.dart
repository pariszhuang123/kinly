// lib/features/hub/ui/hub_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/kinly_selection_card.dart';
import '../../../generated/l10n.dart';

import '../bloc/hub_bloc.dart';
import 'widget/hub_member_section.dart';
import 'widget/hub_qr_section.dart';

class HubScreen extends StatelessWidget {
  final String homeId;
  const HubScreen({super.key, required this.homeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    return PopScope(
      // ❗ Prevent this route from being popped by back button / gesture
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          title: Text(s.navHub),
          // Just in case, make sure no back arrow is shown
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

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
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
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 👥 Members section
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
                                SizedBox(height: spacing.xl),

                                // 🔳 QR / app link section
                                HubQrSection(
                                  state: state,
                                  onShareAppTap:
                                      () => _shareAppLink(context, state),
                                  onQrTap: () => _showQrSheet(context, state),
                                ),
                                SizedBox(height: spacing.xl),

                                // 🧡 Gratitude Wall card
                                KinlySelectionCard(
                                  colors: sections.hub,
                                  title: s.hubCardGratitudeWallTitle,
                                  subtitle: s.hubCardGratitudeWallSubtitle,
                                  icon: Icons.favorite_rounded,
                                  onTap:
                                      () =>
                                          context.push(AppRoutes.gratitudeWall),
                                ),

                                // 👉 Add more Hub “vibe” cards here later if needed
                              ],
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
                // Already on Hub
                break;
            }
          },
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // SHARE INVITE (with fixed \n behavior)
  // --------------------------------------------------------------
  Future<void> _shareInvite(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (!state.hasInvite) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubInviteUnavailable)));
      context.read<HubBloc>().add(const HubRefreshed());
      return;
    }

    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';

    // ARB already provides real newlines; this ensures any stray literal "\n" become newlines.
    final raw = s.hubShareInviteBody(state.inviteCode, appLink);
    final message = raw.replaceAll(r'\n', '\n');

    await Share.share(message, subject: s.hubShareInviteTitle);
  }

  // --------------------------------------------------------------
  // SHARE APP LINK (also normalized)
  // --------------------------------------------------------------
  Future<void> _shareAppLink(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (state.appLink.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubInviteUnavailable)));
      return;
    }

    final raw = s.hubShareAppBody(state.appLink);
    final message = raw.replaceAll(r'\n', '\n');

    await Share.share(message, subject: s.hubShareAppTitle);
  }

  Future<void> _copyInviteCode(BuildContext context, HubState state) async {
    final s = S.of(context);

    if (!state.hasInvite || state.inviteCode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubInviteUnavailable)));
      return;
    }

    await Clipboard.setData(ClipboardData(text: state.inviteCode));
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(s.hubCodeCopied)));
  }

  Future<void> _rotateInvite(BuildContext context) async {
    final s = S.of(context);
    try {
      context.read<HubBloc>().add(const HubInviteRotated());
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubRotateSuccess)));
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubRotateError)));
    }
  }

  // --------------------------------------------------------------
  // QR Bottom Sheet
  // --------------------------------------------------------------
  void _showQrSheet(BuildContext context, HubState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.lg + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.hubQrTitle, style: theme.textTheme.titleMedium),
              SizedBox(height: spacing.md),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(spacing.lg),
                child: HubQrCode(
                  data: appLink,
                  isDark: isDark,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                s.hubQrSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),
              KinlyFilledButton.icon(
                onPressed: () => _shareAppLink(context, state),
                icon: Icons.ios_share_rounded,
                label: s.hubShareAppCta,
                fullWidth: true,
              ),
            ],
          ),
        );
      },
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
