import 'package:flutter/material.dart';

import '../../../../../core/ui/kinly_loader.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            title != null
                ? Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
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
    return Image.network(
      photoUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: KinlyLoader(size: 32, color: Colors.white));
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.white70, size: 48),
        );
      },
    );
  }
}
