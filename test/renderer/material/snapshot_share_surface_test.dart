import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/renderer/material/share/snapshot_share_surface.dart';

void main() {
  testWidgets(
    'SnapshotShareSurface paints surface color behind captured content',
    (tester) async {
      const surfaceColor = Color(0xFF112233);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light().copyWith(
              surface: surfaceColor,
            ),
          ),
          home: SnapshotShareSurface(
            fileNamePrefix: 'test',
            logTag: 'test',
            subjectBuilder: (_) => 'subject',
            messageBuilder: (_, __) => 'message',
            capturedChildBuilder: (_) => const SizedBox.shrink(),
            builder: (_, __, ___, capturedChild) => capturedChild,
          ),
        ),
      );

      final boundary = find.byType(RepaintBoundary);
      final wrapperWithSurfaceColor = find.descendant(
        of: boundary,
        matching: find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == surfaceColor,
          description: 'ColoredBox using theme surface color',
        ),
      );

      expect(wrapperWithSurfaceColor, findsOneWidget);
    },
  );
}
