import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KinlyCircleAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;

  const KinlyCircleAvatar({super.key, this.avatarUrl, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final showsSvgAvatar =
        avatarUrl != null && avatarUrl!.trim().toLowerCase().endsWith('.svg');

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      backgroundImage:
          avatarUrl != null && !showsSvgAvatar
              ? NetworkImage(avatarUrl!)
              : null,
      child: switch ((avatarUrl, showsSvgAvatar)) {
        // -----------------------------------------
        // No avatar → empty circle (no initials)
        // -----------------------------------------
        (null, _) => null,

        // -----------------------------------------
        // SVG avatar → fill entire circle
        // -----------------------------------------
        (_, true) => ClipOval(
          child: SizedBox.expand(
            child: SvgPicture.network(
              avatarUrl!,
              fit: BoxFit.cover,
              placeholderBuilder:
                  (_) => Center(
                    child: SizedBox(
                      width: radius,
                      height: radius,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
            ),
          ),
        ),

        // -----------------------------------------
        // Raster image handled via backgroundImage
        // -----------------------------------------
        _ => null,
      },
    );
  }
}
