// lib/core/share/snapshot_share_surface.dart
import 'package:flutter/material.dart';

import 'snapshot_sharer.dart';

typedef SnapshotSubjectBuilder = String Function(BuildContext context);
typedef SnapshotMessageBuilder =
    String Function(BuildContext context, String appLink);

/// Generic surface that:
/// - wraps [capturedChildBuilder] in a RepaintBoundary
/// - exposes [onShare] + [isSharing] to a [builder]
/// - uses [SnapshotSharer] internally
class SnapshotShareSurface extends StatefulWidget {
  const SnapshotShareSurface({
    super.key,
    required this.fileNamePrefix,
    required this.logTag,
    required this.subjectBuilder,
    required this.messageBuilder,
    required this.capturedChildBuilder,
    required this.builder,
    this.onShareError,
  });

  /// Prefix for the PNG filename (e.g. "gratitude_wall", "house_rules").
  final String fileNamePrefix;

  /// Log tag used by SnapshotSharer (e.g. "GratitudeWallShare").
  final String logTag;

  /// Builds the share subject (usually from localization).
  final SnapshotSubjectBuilder subjectBuilder;

  /// Builds the share message, given [appLink].
  final SnapshotMessageBuilder messageBuilder;

  /// Builds the content to be captured in the RepaintBoundary.
  final Widget Function(BuildContext context) capturedChildBuilder;

  /// Layout builder that receives:
  /// - [isSharing] flag
  /// - [onShare] callback
  /// - [capturedChild] widget (already wrapped in RepaintBoundary)
  final Widget Function(
    BuildContext context,
    bool isSharing,
    Future<void> Function() onShare,
    Widget capturedChild,
  )
  builder;

  /// Optional error handler when sharing fails.
  /// Useful to show a SnackBar, dialog, etc.
  final void Function(BuildContext context)? onShareError;

  @override
  State<SnapshotShareSurface> createState() => _SnapshotShareSurfaceState();
}

class _SnapshotShareSurfaceState extends State<SnapshotShareSurface> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final capturedChild = RepaintBoundary(
      key: _repaintKey,
      child: widget.capturedChildBuilder(context),
    );

    return widget.builder(
      context,
      _isSharing,
      () => _handleShare(context),
      capturedChild,
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    final success = await SnapshotSharer.shareRepaintBoundary(
      context: context,
      repaintKey: _repaintKey,
      fileNamePrefix: widget.fileNamePrefix,
      logTag: widget.logTag,
      subject: widget.subjectBuilder(context),
      messageBuilder: (appLink) => widget.messageBuilder(context, appLink),
    );

    if (!mounted) return;

    if (!success && widget.onShareError != null) {
      widget.onShareError!(context);
    }

    setState(() => _isSharing = false);
  }
}
