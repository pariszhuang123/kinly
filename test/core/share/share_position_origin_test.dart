import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kinly/core/share/share_position_origin.dart";

void main() {
  testWidgets(
    "returns a non-zero rect when context has a render box",
    (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            key: ValueKey("root"),
            width: 300,
            height: 400,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 16, top: 24),
              child: SizedBox(key: ValueKey("target"), width: 120, height: 80),
            ),
          ),
        ),
      );

      final target = find.byKey(const ValueKey("target"));
      final element = tester.element(target);
      final rect = sharePositionOriginForContext(element);

      expect(rect.width, greaterThan(0));
      expect(rect.height, greaterThan(0));
    },
  );
}
