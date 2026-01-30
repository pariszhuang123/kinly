import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/renderer/material/share/snapshot_sharer.dart';

void main() {
  test(
    'snapshot share app link falls back to go.makinglifeeasie.com when hosts are empty',
    () {
      final link = SnapshotSharer.resolveAppLinkForTest();

      expect(link, 'https://go.makinglifeeasie.com/kinly');
    },
  );
}
