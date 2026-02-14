// lib/core/share/snapshot_sharer.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/locator.dart';
import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';
import '../../../core/share/share_position_origin.dart';

/// Generic sharer for any RepaintBoundary-based surface.
///
/// Can be used for:
/// - Gratitude wall (house)
/// - Personalized gratitude summary
/// - House rules card
/// - Personal preferences card, etc.
class SnapshotSharer {
  const SnapshotSharer._();

  /// Captures the widget behind [repaintKey] and shares it as a PNG.
  ///
  /// Returns `true` if the share was triggered successfully,
  /// `false` if something failed (boundary missing, capture error, etc).
  static Future<bool> shareRepaintBoundary({
    required BuildContext context,
    required GlobalKey repaintKey,
    required String fileNamePrefix,
    required String logTag,
    required String subject,
    required String Function(String appLink) messageBuilder,
  }) async {
    final logger =
        sl.isRegistered<Logger>() ? sl<Logger>() : const DebugLogger();

    try {
      final boundary =
          repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        logger.warn(
          'RepaintBoundary not found for snapshot share',
          tag: logTag,
        );
        return false;
      }

      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        logger.warn(
          'Failed to encode snapshot to PNG (byteData null)',
          tag: logTag,
        );
        return false;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/'
        '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      final appLink = _resolveAppLink();
      final message = messageBuilder(appLink);
      final shareOrigin = sharePositionOriginForContext(context);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: subject,
        text: message,
        sharePositionOrigin: shareOrigin,
      );

      logger.info('Shared snapshot image', tag: logTag);
      return true;
    } catch (error, stack) {
      logger.warn(
        'Failed to share snapshot',
        tag: logTag,
        error: error,
        stackTrace: stack,
      );
      return false;
    }
  }

  @visibleForTesting
  static String resolveAppLinkForTest() => _resolveAppLink();

  static String _resolveAppLink() {
    final host =
        AppConfig.inviteHost.isNotEmpty
            ? AppConfig.inviteHost
            : (AppConfig.deeplinkHost.isNotEmpty
                ? AppConfig.deeplinkHost
                : 'go.makinglifeeasie.com');
    if (host.isEmpty) return 'https://go.makinglifeeasie.com/kinly';
    final uri = Uri(
      scheme: 'https',
      host: host,
      pathSegments: const ['kinly'],
    );
    return uri.toString();
  }
}
