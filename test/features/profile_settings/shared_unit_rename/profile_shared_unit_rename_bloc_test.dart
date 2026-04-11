import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/features/profile_settings/shared_unit_rename/bloc/profile_shared_unit_rename_bloc.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

void main() {
  late _MockHomeUnitsRepository homeUnitsRepository;

  ProfileSharedUnitRenameBloc buildBloc() {
    return ProfileSharedUnitRenameBloc(
      homeUnitsRepository: homeUnitsRepository,
      unitId: 'unit-shared',
      initialName: 'Old name',
    );
  }

  setUp(() {
    homeUnitsRepository = _MockHomeUnitsRepository();
  });

  blocTest<ProfileSharedUnitRenameBloc, ProfileSharedUnitRenameState>(
    'submits renamed shared unit',
    build: () {
      when(
        () => homeUnitsRepository.renameSharedUnit(
          unitId: any(named: 'unitId'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => 'unit-shared');
      return buildBloc();
    },
    seed: () => const ProfileSharedUnitRenameState(name: 'New name'),
    act: (bloc) => bloc.add(const ProfileSharedUnitRenameSubmitted()),
    expect: () => const [
      ProfileSharedUnitRenameState(
        name: 'New name',
        status: ProfileSharedUnitRenameStatus.submitting,
      ),
      ProfileSharedUnitRenameState(
        name: 'New name',
        status: ProfileSharedUnitRenameStatus.success,
      ),
    ],
  );

  blocTest<ProfileSharedUnitRenameBloc, ProfileSharedUnitRenameState>(
    'emits failure when rename shared unit fails',
    build: () {
      when(
        () => homeUnitsRepository.renameSharedUnit(
          unitId: any(named: 'unitId'),
          name: any(named: 'name'),
        ),
      ).thenThrow(Exception('rename failed'));
      return buildBloc();
    },
    seed: () => const ProfileSharedUnitRenameState(name: ' New name '),
    act: (bloc) => bloc.add(const ProfileSharedUnitRenameSubmitted()),
    expect: () => const [
      ProfileSharedUnitRenameState(
        name: ' New name ',
        status: ProfileSharedUnitRenameStatus.submitting,
      ),
      ProfileSharedUnitRenameState(
        name: ' New name ',
        status: ProfileSharedUnitRenameStatus.failure,
        errorMessage: 'Exception: rename failed',
      ),
    ],
    verify: (_) {
      verify(
        () => homeUnitsRepository.renameSharedUnit(
          unitId: 'unit-shared',
          name: 'New name',
        ),
      ).called(1);
    },
  );

  test('canSubmit trims whitespace-only names', () {
    const blank = ProfileSharedUnitRenameState(name: '   ');
    const valid = ProfileSharedUnitRenameState(name: '  Alex + Sam  ');

    expect(blank.canSubmit, isFalse);
    expect(valid.canSubmit, isTrue);
    expect(valid.trimmedName, 'Alex + Sam');
  });
}
