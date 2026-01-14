import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/network/enums/connectivity_status.dart';

void main() {
  group('ConnectivityStatus', () {
    test('has 3 values', () {
      expect(ConnectivityStatus.values.length, 3);
    });

    test('unknown is a value', () {
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.unknown));
    });

    test('online is a value', () {
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.online));
    });

    test('offline is a value', () {
      expect(ConnectivityStatus.values, contains(ConnectivityStatus.offline));
    });

    test('unknown is first (index 0)', () {
      expect(ConnectivityStatus.values[0], ConnectivityStatus.unknown);
    });

    test('values have correct indices', () {
      expect(ConnectivityStatus.unknown.index, 0);
      expect(ConnectivityStatus.online.index, 1);
      expect(ConnectivityStatus.offline.index, 2);
    });
  });
}
