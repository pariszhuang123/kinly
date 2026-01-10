import 'package:flutter/material.dart';

class KinlyDropdownMenuItem {
  const KinlyDropdownMenuItem._();

  static DropdownMenuItem<T> item<T>({
    required T value,
    required Widget child,
  }) {
    return DropdownMenuItem<T>(value: value, child: child);
  }
}
