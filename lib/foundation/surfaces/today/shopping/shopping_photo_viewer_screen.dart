import 'package:flutter/widgets.dart';

import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

class ShoppingPhotoViewerScreen extends StatelessWidget {
  const ShoppingPhotoViewerScreen({
    super.key,
    required this.photoUrl,
    required this.title,
  });

  final String photoUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(title)),
      body: SafeArea(
        child: SizedBox.expand(
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
                  (context, error, stackTrace) =>
                      const Center(child: Icon(KinlyIcons.brokenImage, size: 48)),
            ),
          ),
        ),
      ),
    );
  }
}
