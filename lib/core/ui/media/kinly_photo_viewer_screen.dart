import 'package:flutter/widgets.dart';

import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';

class KinlyPhotoViewerScreen extends StatelessWidget {
  const KinlyPhotoViewerScreen({
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
    return KinlyScaffold(
      appBar: KinlyAppBar(title: title == null ? null : Text(title!)),
      body: SafeArea(
        child: SizedBox.expand(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              clipBehavior: Clip.none,
              child: Image.network(
                photoUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: KinlyLoader(size: 32));
                },
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(KinlyIcons.brokenImage, size: 48),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
