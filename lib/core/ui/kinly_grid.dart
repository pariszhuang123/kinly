import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class KinlyGrid {
  const KinlyGrid._();

  static Widget sliver({
    required List<Widget> children,
    required double minTileWidth,
    required double spacing,
    double? runSpacing,
    double childAspectRatio = 1.0,
    int? crossAxisCount,
  }) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final resolvedCount =
            crossAxisCount ??
            math.max(
              1,
              ((constraints.crossAxisExtent + spacing) /
                      (minTileWidth + spacing))
                  .floor(),
            );
        return SliverGrid(
          delegate: SliverChildListDelegate(children),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: resolvedCount,
            mainAxisSpacing: runSpacing ?? spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
        );
      },
    );
  }
}
