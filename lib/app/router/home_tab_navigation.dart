import 'package:flutter/widgets.dart';

const int homeTabIndexToday = 0;
const int homeTabIndexExplore = 1;
const int homeTabIndexHub = 2;

class HomeTabNavExtra {
  const HomeTabNavExtra({required this.fromIndex});

  final int fromIndex;
}

HomeTabNavExtra? homeTabNavExtraFrom(Object? extra) {
  if (extra is HomeTabNavExtra) {
    return extra;
  }
  return null;
}

Offset homeTabEntryOffset({
  required int targetIndex,
  required HomeTabNavExtra? navExtra,
}) {
  if (navExtra == null || navExtra.fromIndex == targetIndex) {
    return Offset.zero;
  }
  final isForward = navExtra.fromIndex < targetIndex;
  return isForward ? const Offset(1, 0) : const Offset(-1, 0);
}
