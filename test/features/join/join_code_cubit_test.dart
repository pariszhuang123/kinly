import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/features/join/ui/join_home_screen.dart';

void main() {
  group('JoinCodeCubit', () {
    test('initial state is empty', () {
      final cubit = JoinCodeCubit();
      expect(cubit.state, '');
      cubit.close();
    });

    blocTest<JoinCodeCubit, String>(
      'emits trimmed code on update',
      build: () => JoinCodeCubit(),
      act: (cubit) => cubit.update('  AbC123  '),
      expect: () => ['AbC123'],
    );
  });
}

