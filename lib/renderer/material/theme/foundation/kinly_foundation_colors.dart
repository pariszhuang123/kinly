import 'package:flutter/material.dart';

/// Immutable, single source of truth for Kinly foundation colors.
/// These are the only hard-coded hex values allowed; everything else
/// should be derived from these inputs in higher-level contracts.
class KinlyFoundationColors {
  const KinlyFoundationColors._();

  // Surfaces
  static const Color surfaceLight = Color(0xFFFAFAF9);
  static const Color surfaceDark = Color(0xFF101312);

  // Brand
  static const Color brandPrimary = Color(0xFF366D59); // Kinly Teal
  static const Color brandSecondary = Color(0xFF8BAA91); // Sage
  static const Color brandAccent = Color(0xFFF6B73C); // Honey

  // Neutral ink & structure
  static const Color ink = Color(0xFF101312);
  static const Color outline = Color(0xFFB7C7C0);

  // Semantics
  static const Color error = Color(0xFFE53935);
}

