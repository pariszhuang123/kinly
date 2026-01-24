import 'package:flutter/widgets.dart';

import '../../../../core/ui/branding/kinly_logo.dart';
import '../../../../core/ui/kinly_tap_target.dart';

class TappableKinlyLogo extends StatelessWidget {
  const TappableKinlyLogo({
    super.key,
    required this.onTap,
    this.size = 96,
  });

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return KinlyTapTarget(
      onTap: onTap,
      child: KinlyLogo(size: size),
    );
  }
}
