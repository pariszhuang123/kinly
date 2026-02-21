import 'package:flutter/widgets.dart';

import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_scaffold.dart';

class SharePhotoViewerScreen extends StatelessWidget {
  const SharePhotoViewerScreen({
    super.key,
    required this.photoUrl,
    required this.title,
    required this.heroTag,
  });

  final String photoUrl;
  final String title;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(title)),
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
