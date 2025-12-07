import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';
import '../kinly_loader.dart';

/// Reusable photo capture/preview tile.
class KinlyPhotoCapture extends StatelessWidget {
  const KinlyPhotoCapture({
    super.key,
    this.photoUrl,
    required this.label,
    required this.placeholderText,
    required this.onTap,
    this.isUploading = false,
    this.aspectRatio = 4 / 3,
  });

  final String? photoUrl;
  final String label;
  final String placeholderText;
  final VoidCallback onTap;
  final bool isUploading;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();

    final hasPhoto = photoUrl?.trim().isNotEmpty == true;

    final preview = Container(
      decoration: BoxDecoration(
        color: colors?.surfaceVariant ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child:
                hasPhoto && photoUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        corners?.medium ?? 12,
                      ),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Center(
                              child: Text(
                                placeholderText,
                                style: (type?.bodyMedium ??
                                        theme.textTheme.bodyMedium)
                                    ?.copyWith(color: colorScheme.error),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      ),
                    )
                    : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 32,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: spacing?.xs ?? 8),
                          Text(
                            placeholderText,
                            style: (type?.bodyMedium ??
                                    theme.textTheme.bodyMedium)
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
          ),
          if (isUploading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(corners?.medium ?? 12),
              ),
              child: const Center(child: KinlyLoader(size: 32)),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: type?.titleSmall ?? theme.textTheme.titleSmall),
        SizedBox(height: spacing?.xs ?? 8),
        Semantics(
          button: true,
          enabled: !isUploading,
          label: label,
          child: GestureDetector(
            onTap: isUploading ? null : onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
              child: AspectRatio(aspectRatio: aspectRatio, child: preview),
            ),
          ),
        ),
      ],
    );
  }
}
