import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/renderer/material/ui/selector/kinly_selectable_item_row.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(
      extensions: const <ThemeExtension<dynamic>>[KinlyOpacity.defaults],
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

KinlySelectableItem<String> _item(String value, String label) {
  return KinlySelectableItem<String>(
    value: value,
    label: label,
    builder:
        (_, __) => Container(
          width: 40,
          height: 40,
          color: Colors.blue,
        ),
  );
}

void main() {
  testWidgets('shows label only when selected', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableItemRow<String>(
          items: [_item('a', 'Alpha')],
          selectedValues: const {'a'},
          onToggle: (_) {},
          showLabels: false,
          showLabelOnSelected: true,
        ),
      ),
    );

    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('does not show empty labels on selection', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlySelectableItemRow<String>(
          items: [_item('a', '')],
          selectedValues: const {'a'},
          onToggle: (_) {},
          showLabels: false,
          showLabelOnSelected: true,
        ),
      ),
    );

    final emptyTextFinder = find.byWidgetPredicate(
      (widget) => widget is Text && widget.data == '',
    );
    expect(emptyTextFinder, findsNothing);
  });
}
