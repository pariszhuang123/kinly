import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/elevation.dart';
import '../theme/kinly_palette.dart';
import '../theme/motion.dart';
import '../theme/opacity.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import 'kinly_motion_aware.dart';

class KinlyBottomSheet extends StatelessWidget {
  const KinlyBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.footer = const [],
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget> footer;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget body,
    List<Widget> footer = const [],
    bool isScrollControlled = true,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      // ✅ Let Flutter handle system bars insets (status / gesture areas).
      useSafeArea: false,
      builder:
          (_) => KinlyBottomSheet(
            title: title,
            subtitle: subtitle,
            body: body,
            footer: footer,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motionAware = KinlyMotionAware.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colors = theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final corners = theme.extension<Corners>();
    final elevations = theme.extension<Elevations>();
    final motion = theme.extension<Motion>();
    final opacities = theme.extension<KinlyOpacity>()!;

    // Only respond to keyboard inset. System insets are handled by useSafeArea: true.
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    final radius = corners?.xlarge ?? 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedPadding(
          padding: EdgeInsetsDirectional.fromSTEB(
            0,
            spacing.lg, // some air from top when dragged up
            0,
            spacing.lg + bottomInset, // base spacing + keyboard height (if any)
          ),
          duration: motionAware.effectiveDuration(
            motion?.durationMedium ?? const Duration(milliseconds: 200),
          ),
          curve: motion?.easeEmotional ?? Curves.easeOutCubic,
          child: Material(
            elevation: elevations?.level4 ?? 10,
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            ),
            clipBehavior: Clip.antiAlias, // nicer corners on tall sheets
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.xl,
                spacing.m,
                spacing.xl,
                spacing.m,
              ),
              child: SafeArea(
                top: false,
                bottom: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          primary: false,
                          // Keep header/body scrollable while footer stays pinned.
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Drag handle
                              Container(
                                width: 36,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.onSurface.withValues(
                                    alpha: opacities.alphaHalo,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(height: spacing.md),

                              // Title
                              Text(
                                title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              // Subtitle (optional)
                              if (subtitle != null) ...[
                                SizedBox(height: spacing.sm),
                                Text(
                                  subtitle!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurface.withValues(
                                      alpha: opacities.alphaFaint,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],

                              SizedBox(height: spacing.lg),

                              // Main body (HarmonyScreen, etc.)
                              body,
                            ],
                          ),
                        ),
                      ),

                      // Footer actions (buttons, etc.)
                      if (footer.isNotEmpty) ...[
                        SizedBox(height: spacing.xl),
                        ...footer,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
