import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/features/profile_settings/shared_unit_create/bloc/profile_shared_unit_create_bloc.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

void main() {
  late _MockHomeUnitsRepository homeUnitsRepository;

  ProfileSharedUnitCreateBloc buildBloc() {
    return ProfileSharedUnitCreateBloc(
      homeUnitsRepository: homeUnitsRepository,
      homeId: 'home-1',
      creatorMembershipId: 'membership-1',
    );
  }

  setUp(() {
    homeUnitsRepository = _MockHomeUnitsRepository();
  });

  blocTest<ProfileSharedUnitCreateBloc, ProfileSharedUnitCreateState>(
    'loads eligible candidates on start',
    build: () {
      when(
        () => homeUnitsRepository.listCreateSharedUnitCandidates(
          homeId: any(named: 'homeId'),
        ),
      ).thenAnswer(
        (_) async => const <HomeUnitMemberCandidate>[
          HomeUnitMemberCandidate(
            membershipId: 'membership-2',
            userId: 'user-2',
            displayName: 'Sam',
          ),
        ],
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ProfileSharedUnitCreateStarted()),
    expect: () => const [
      ProfileSharedUnitCreateState(
        status: ProfileSharedUnitCreateStatus.loading,
      ),
      ProfileSharedUnitCreateState(
        status: ProfileSharedUnitCreateStatus.ready,
        candidates: <HomeUnitMemberCandidate>[
          HomeUnitMemberCandidate(
            membershipId: 'membership-2',
            userId: 'user-2',
            displayName: 'Sam',
          ),
        ],
      ),
    ],
  );

  blocTest<ProfileSharedUnitCreateBloc, ProfileSharedUnitCreateState>(
    'submits creator plus selected candidates',
    build: () {
      when(
        () => homeUnitsRepository.createSharedUnit(
          homeId: any(named: 'homeId'),
          name: any(named: 'name'),
          membershipIds: any(named: 'membershipIds'),
        ),
      ).thenAnswer((_) async => 'unit-1');
      return buildBloc();
    },
    seed: () => const ProfileSharedUnitCreateState(
      name: 'Alex + Sam',
      selectedMembershipIds: <String>{'membership-2'},
      status: ProfileSharedUnitCreateStatus.ready,
    ),
    act: (bloc) => bloc.add(const ProfileSharedUnitCreateSubmitted()),
    expect: () => const [
      ProfileSharedUnitCreateState(
        name: 'Alex + Sam',
        selectedMembershipIds: <String>{'membership-2'},
        status: ProfileSharedUnitCreateStatus.submitting,
      ),
      ProfileSharedUnitCreateState(
        name: 'Alex + Sam',
        selectedMembershipIds: <String>{'membership-2'},
        status: ProfileSharedUnitCreateStatus.success,
      ),
    ],
    verify: (_) {
      verify(
        () => homeUnitsRepository.createSharedUnit(
          homeId: 'home-1',
          name: 'Alex + Sam',
          membershipIds: <String>['membership-1', 'membership-2'],
        ),
      ).called(1);
    },
  );
}
