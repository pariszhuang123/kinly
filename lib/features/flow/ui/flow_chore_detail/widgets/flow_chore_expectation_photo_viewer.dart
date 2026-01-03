import 'package:flutter/widgets.dart';

import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/ui/kinly_scaffold.dart';
import '../../../../../core/ui/kinly_app_bar.dart';
import '../../../../../core/ui/kinly_theme_access.dart';
import '../../../../../core/theme/color_tokens.dart';
import '../../../../../core/theme/opacity.dart';
import '../../../../../core/ui/kinly_icons.dart';

class FlowChorePhotoViewerArgs {
  const FlowChorePhotoViewerArgs({
    required this.photoUrl,
    required this.heroTag,
    this.title,
  });

  final String photoUrl;
  final Object heroTag;
  final String? title;
}

class FlowChoreExpectationPhotoViewerPage extends StatelessWidget {
  const FlowChoreExpectationPhotoViewerPage({
    super.key,
    required this.photoUrl,
    required this.heroTag,
    this.title,
  });

  final String photoUrl;
  final Object heroTag;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colors = theme.extension<KinlyColorTokens>();
    final background = colors?.inverseSurface ?? theme.colorScheme.inverseSurface;
    final foreground =
        colors?.onInverseSurface ?? theme.colorScheme.onInverseSurface;

    return KinlyScaffold(
      backgroundColor: background,
      appBar: KinlyAppBar(
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: background,
        iconTheme: IconThemeData(color: foreground),
        title:
            title != null
                ? Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                  ),
                )
                : null,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              clipBehavior: Clip.none,
              child: _NetworkImageWithLoader(photoUrl: photoUrl),
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithLoader extends StatelessWidget {
  const _NetworkImageWithLoader({required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colors = theme.extension<KinlyColorTokens>();
    final opacities = theme.extension<KinlyOpacity>();
    final foreground =
        colors?.onInverseSurface ?? theme.colorScheme.onInverseSurface;
    return Image.network(
      photoUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(child: KinlyLoader(size: 32, color: foreground));
      },
      errorBuilder: (context, error, stackTrace) {
        final iconColor =
            opacities == null
                ? foreground
                : foreground.withValues(alpha: opacities.alphaFaint);
        return Center(
          child: Icon(KinlyIcons.brokenImage, color: iconColor, size: 48),
        );
      },
    );
  }
}




