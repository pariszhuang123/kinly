import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/kinly_sections.dart';
import '../theme/kinly_palette.dart';
import '../theme/spacing.dart';

/// Reusable, centered two-column masonry grid that balances item heights.
/// Useful for gratitude walls, personal walls, house rules, etc.
class KinlyMasonryGrid<T> extends StatelessWidget {
  const KinlyMasonryGrid({
    super.key,
    required this.items,
    required this.builder,
    required this.estimateItemHeight,
    this.maxWidth,
    this.gap,
    this.palette,
  });

  final List<T> items;
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    KinlySectionPalette palette,
  )
  builder;
  final double Function(T item, TextTheme textTheme, Spacing spacing)
  estimateItemHeight;
  final double? maxWidth;
  final double? gap;
  final KinlySectionPalette? palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final textTheme = theme.textTheme;
    final palette = this.palette ?? KinlySectionPalette.fromTheme(theme);
    final columns = _splitIntoColumns(
      items: items,
      spacing: spacing,
      textTheme: textTheme,
      estimateItemHeight: estimateItemHeight,
    );
    final columnGap = gap ?? spacing.lg;

    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth =
            maxWidth == null
                ? constraints.maxWidth
                : math.min(constraints.maxWidth, maxWidth!);

        return Align(
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: targetWidth),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _KinlyMasonryColumn<T>(
                    items: columns[0],
                    palette: palette,
                    spacing: spacing,
                    builder: builder,
                  ),
                ),
                SizedBox(width: columnGap),
                Expanded(
                  child: _KinlyMasonryColumn<T>(
                    items: columns[1],
                    palette: palette,
                    spacing: spacing,
                    builder: builder,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KinlyMasonryColumn<T> extends StatelessWidget {
  const _KinlyMasonryColumn({
    required this.items,
    required this.palette,
    required this.spacing,
    required this.builder,
  });

  final List<T> items;
  final KinlySectionPalette palette;
  final Spacing spacing;
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    KinlySectionPalette palette,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: spacing.lg),
          builder(context, items[i], i, palette),
        ],
      ],
    );
  }
}

class KinlySectionPalette {
  KinlySectionPalette(this.colors);

  factory KinlySectionPalette.fromTheme(ThemeData theme) {
    final sections = theme.extension<KinlySections>();
    final colors = <SectionColors>[
      if (sections != null) ...[sections.flow, sections.share, sections.pulse],
    ];
    if (colors.isNotEmpty) return KinlySectionPalette(colors);

    final derivedSections = KinlyPalette.build(theme.brightness).sections;
    return KinlySectionPalette([
      derivedSections.flow,
      derivedSections.share,
      derivedSections.pulse,
    ]);
  }

  final List<SectionColors> colors;

  SectionColors colorForSeed(String seed) {
    if (colors.isEmpty) {
      return SectionColors(
        background: Colors.transparent,
        card: Colors.transparent,
        icon: Colors.transparent,
        accent: Colors.transparent,
      );
    }
    var hash = 0;
    for (final codeUnit in seed.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    final index = hash % colors.length;
    return colors[index];
  }
}

List<List<T>> _splitIntoColumns<T>({
  required List<T> items,
  required Spacing spacing,
  required TextTheme textTheme,
  required double Function(T item, TextTheme textTheme, Spacing spacing)
  estimateItemHeight,
}) {
  final columns = <List<T>>[<T>[], <T>[]];
  final heights = <double>[0, 0];

  for (int i = 0; i < items.length; i++) {
    final item = items[i];
    final estimatedHeight = estimateItemHeight(item, textTheme, spacing);
    final target = heights[0] <= heights[1] ? 0 : 1;
    columns[target].add(item);
    heights[target] += estimatedHeight;
  }

  return columns;
}
