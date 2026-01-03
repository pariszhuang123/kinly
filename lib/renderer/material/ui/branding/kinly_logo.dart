import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KinlyLogo extends StatelessWidget {
  const KinlyLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/logo/Kinly logo.svg',
      width: size,
      height: size,
    );
  }
}
