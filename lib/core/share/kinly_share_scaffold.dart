import 'package:flutter/material.dart';
import 'snapshot_share_surface.dart';
import '../theme/spacing.dart';
import '../../generated/l10n.dart';

/// A reusable Kinly-standard scaffold for any shareable screen.
///
/// Provides:
/// - AppBar
/// - Floating share FAB
/// - Integrated SnapshotShareSurface
/// - RepaintBoundary capture
/// - Standardized error handling
/// - Light/dark-aware FAB design
///
/// Ideal for:
/// - Gratitude Wall share
/// - House Rules share
/// - Personal Gratitude summary
/// - Year-in-review
/// - Personal Preferences share card
///
class KinlyShareScaffold extends StatelessWidget {
  const KinlyShareScaffold({
    super.key,
    required this.fileNamePrefix,
    required this.logTag,
    required this.subjectBuilder,
    required this.messageBuilder,
    required this.childBuilder,
    this.appBarTitle,
    this.centerTitle = false,
  });

  /// PNG prefix: e.g. "gratitude_wall", "house_rules", "personal_prefs"
  final String fileNamePrefix;

  /// Log tag used internally.
  final String logTag;

  /// Builds the subject string for sharing.
  final String Function(BuildContext context) subjectBuilder;

  /// Builds the share message (with app link).
  final String Function(BuildContext context, String appLink) messageBuilder;

  /// Builds the *content that will be captured* (inside a RepaintBoundary).
  final Widget Function(BuildContext context) childBuilder;

  /// Optional AppBar title.
  final String? appBarTitle;

  /// Whether AppBar title is centered.
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return SnapshotShareSurface(
      fileNamePrefix: fileNamePrefix,
      logTag: logTag,
      subjectBuilder: subjectBuilder,
      messageBuilder: messageBuilder,
      onShareError: (ctx) {
        final s = S.of(ctx);
        ScaffoldMessenger.of(
          ctx,
        ).showSnackBar(SnackBar(content: Text(s.gratitudeWallShareError)));
      },
      // This builds only the captured content.
      capturedChildBuilder: childBuilder,
      // This builds the full page (Scaffold + FAB + capturedChild).
      builder: (ctx, isSharing, onShare, capturedChild) {
        final theme = Theme.of(ctx);
        final spacing = theme.extension<Spacing>()!;
        final s = S.of(ctx);

        return Scaffold(
          appBar: AppBar(
            title: appBarTitle != null ? Text(appBarTitle!) : null,
            centerTitle: centerTitle,
          ),

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: capturedChild,
            ),
          ),

          floatingActionButton: IgnorePointer(
            ignoring: isSharing,
            child: FloatingActionButton.extended(
              heroTag: '${fileNamePrefix}_fab',
              onPressed: onShare,
              label: Text(s.gratitudeWallShareCta),
              icon: const Icon(Icons.ios_share_rounded),
            ),
          ),
        );
      },
    );
  }
}
