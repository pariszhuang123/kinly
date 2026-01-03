part of '../flow_chore_screen.dart';

class _ExpectationPhotoPicker extends StatelessWidget {
  const _ExpectationPhotoPicker({
    required this.spacing,
    required this.s,
    required this.isUploading,
    required this.photoUrl,
    required this.onCapture,
  });

  final Spacing? spacing;
  final S s;
  final bool isUploading;
  final String? photoUrl;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPhoto = photoUrl?.trim().isNotEmpty == true;

    final preview = Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child:
                hasPhoto && photoUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Center(
                              child: Text(
                                s.flowChorePhotoLoadError,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
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
                          const SizedBox(height: 8),
                          Text(
                            s.flowChorePhotoPlaceholder,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
          if (isUploading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).extension<KinlyOpacity>()!.alphaHalo,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: KinlyLoader(size: 32)),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.flowChorePhotoLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing?.xs ?? 8),
        KinlyTapTarget(
          onTap: isUploading ? null : onCapture,
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(aspectRatio: 4 / 3, child: preview),
        ),
      ],
    );
  }
}
