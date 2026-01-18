import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinly/renderer/material/share/snapshot_share_surface.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/renderer/material/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/buttons/kinly_fab.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

/// A reusable Kinly-standard scaffold for "Story" style share screens.
///
/// This follows the "HouseVibeShareScreen" pattern:
/// - Enforces a 9:16 aspect ratio (Portrait) for the captured content.
/// - Vertically centers the [child] within that aspect ratio.
/// - Provides an AppBar (optional title).
/// - Provides a Floating Share FAB.
/// - Handles Snapshot sharing logic.
class KinlyStoryShareScaffold extends StatelessWidget {
  const KinlyStoryShareScaffold({
    super.key,
    required this.fileNamePrefix,
    required this.logTag,
    required this.subjectBuilder,
    required this.messageBuilder,
    required this.child,
    this.appBarTitle,
    this.fabTooltip,
    this.onSharePressed,
  });

  /// PNG prefix: e.g. "gratitude_wall", "house_rules", "personal_prefs"
  final String fileNamePrefix;

  /// Log tag used internally.
  final String logTag;

  /// Builds the subject string for sharing.
  final String Function(BuildContext context) subjectBuilder;

  /// Builds the share message (with app link).
  final String Function(BuildContext context, String appLink) messageBuilder;

  /// The main content card to be displayed in the center.
  final Widget child;

  /// Optional AppBar title. If null, AppBar is shown without title.
  final String? appBarTitle;

  /// Optional tooltip for the share FAB.
  final String? fabTooltip;

  /// Optional hook invoked when the share FAB is pressed, before sharing.
  final Future<void> Function()? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return SnapshotShareSurface(
      fileNamePrefix: fileNamePrefix,
      logTag: logTag,
      subjectBuilder: subjectBuilder,
      messageBuilder: messageBuilder,
      onShareError: (ctx) {
        final s = S.of(ctx);
        // Using a generic error message or we could add a specific one to args
        KinlySnackBar.showError(ctx, s.houseVibeShareError);
      },
      // This builds the content that will be captured (inside RepaintBoundary).
      // We enforce the 9:16 aspect ratio and centering here.
      capturedChildBuilder: (ctx) => _StoryLayout(child: child),
      // This builds the full page (Scaffold + FAB + capturedChild).
      builder: (ctx, isSharing, onShare, capturedChild) {
        final theme = KinlyThemeAccess.of(ctx);

        // Handle overlay style for status bar
        final surface = theme.colorScheme.surface;
        final overlay =
            theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: surface,
                  systemNavigationBarColor: surface,
                  systemNavigationBarIconBrightness: Brightness.light,
                )
                : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: surface,
                  systemNavigationBarColor: surface,
                  systemNavigationBarIconBrightness: Brightness.dark,
                );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: KinlyScaffold(
            backgroundColor: surface,
            appBar: KinlyAppBar(
              backgroundColor: surface,
              foregroundColor: theme.colorScheme.onSurface,
              title: appBarTitle != null ? Text(appBarTitle!) : null,
            ),
            body: ColoredBox(color: surface, child: capturedChild),
            floatingActionButton: IgnorePointer(
              ignoring: isSharing,
              child: KinlyFab(
                heroTag: '${fileNamePrefix}_share_fab',
                tooltip: fabTooltip ?? 'Share',
                icon: KinlyIcons.iosShareRounded,
                onPressed: () async {
                  await _runShareHook();
                  await onShare();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _runShareHook() async {
    if (onSharePressed == null) return;
    try {
      await onSharePressed!();
    } catch (_) {
      // Swallow logging errors to avoid blocking share.
    }
  }
}

class _StoryLayout extends StatelessWidget {
  const _StoryLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final surface = theme.colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        // Target 9:16 aspect ratio
        var height = width * (16 / 9);

        // If calculated height exceeds available height, scale down retaining ratio
        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * (9 / 16);
        }

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: ColoredBox(
              color: surface,
              child: Padding(
                padding: EdgeInsetsDirectional.all(spacing.xl),
                child: Column(
                  children: [const Spacer(), child, const Spacer()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
