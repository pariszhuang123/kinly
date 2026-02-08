import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Supports BOTH SVG assets and built-in Material icons.
/// Each entry can be either an asset path OR an IconData.
///
/// Usage:
///   SectionAssets.flow.isIcon      → true/false
///   SectionAssets.flow.icon        → IconData?
///   SectionAssets.flow.asset       → String?
///   SectionAssets.flow.build(...)  → Widget
class SectionAsset {
  final String? asset;
  final IconData? icon;

  const SectionAsset.asset(this.asset) : icon = null;
  const SectionAsset.icon(this.icon) : asset = null;

  bool get isIcon => icon != null;
  bool get isAsset => asset != null;

  Widget build({required Color color, required double size}) {
    if (icon != null) {
      return Icon(icon, color: color, size: size);
    }
    return SvgPicture.asset(
      asset!,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

// -------------------------------------------
// Your sections: mix of icon + asset.
// -------------------------------------------

class SectionAssets {
  // 🔄 Flow → Now using Material icon instead of SVG asset
  static const flow = SectionAsset.icon(Icons.autorenew_rounded);

  // 🔁 Share → Still using your SVG asset
  static const share = SectionAsset.asset('assets/icons/feature/Share.svg');

  // ❤️ Pulse / Gratitude → Material filled heart icon
  static const pulse = SectionAsset.icon(Icons.favorite_rounded);

  // 🛒 Shopping → Material basket icon
  static const shopping = SectionAsset.icon(Icons.shopping_basket_outlined);

  // 🟦 Hub → Still SVG asset
  static const hub = SectionAsset.asset('assets/icons/feature/Hub.svg');
}
