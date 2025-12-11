import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';

void main() {
  testWidgets('renders child content through KinlyScrollFade',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KinlyScrollFade(
            child: ListView(
              children: [
                Text('row-1'),
                Text('row-2'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('row-1'), findsOneWidget);
    expect(find.text('row-2'), findsOneWidget);
  });
}
