import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/bloc/profile_shared_unit_join_bloc.dart';

class _MockHomeUnitsRepository extends Mock implements HomeUnitsRepository {}

void main() {
  late _MockHomeUnitsRepository homeUnitsRepository;

  ProfileSharedUnitJoinBloc buildBloc() {
    return ProfileSharedUnitJoinBloc(
      homeUnitsRepository: homeUnitsRepository,
      homeId: 'home-1',
    );
  }

  setUp(() {
    homeUnitsRepository = _MockHomeUnitsRepository();
  });

  blocTest<ProfileSharedUnitJoinBloc, ProfileSharedUnitJoinState>(
    'loads joinable shared units',
    build: () {
      when(
        () => homeUnitsRepository.listJoinableSharedUnits(
          homeId: any(named: 'homeId'),
        ),
      ).thenAnswer(
        (_) async => const <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ProfileSharedUnitJoinStarted()),
    expect: () => const [
      ProfileSharedUnitJoinState(status: ProfileSharedUnitJoinStatus.loading),
      ProfileSharedUnitJoinState(
        status: ProfileSharedUnitJoinStatus.ready,
        units: <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
        selectedUnitId: 'unit-shared',
      ),
    ],
  );

  blocTest<ProfileSharedUnitJoinBloc, ProfileSharedUnitJoinState>(
    'submits selected shared unit successfully',
    build: () {
      when(
        () => homeUnitsRepository.joinSharedUnit(unitId: any(named: 'unitId')),
      ).thenAnswer((_) async => 'unit-shared');
      return buildBloc();
    },
    seed: () => const ProfileSharedUnitJoinState(
      units: <HomeUnitSummary>[
        HomeUnitSummary(
          unitId: 'unit-shared',
          homeId: 'home-1',
          name: 'Alex + Sam',
          unitType: HomeUnitType.shared,
          memberUserIds: <String>['user-1', 'user-2'],
        ),
      ],
      selectedUnitId: 'unit-shared',
      status: ProfileSharedUnitJoinStatus.ready,
    ),
    act: (bloc) => bloc.add(const ProfileSharedUnitJoinSubmitted()),
    expect: () => const [
      ProfileSharedUnitJoinState(
        units: <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
        selectedUnitId: 'unit-shared',
        status: ProfileSharedUnitJoinStatus.submitting,
      ),
      ProfileSharedUnitJoinState(
        units: <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
        selectedUnitId: 'unit-shared',
        status: ProfileSharedUnitJoinStatus.success,
      ),
    ],
  );

  blocTest<ProfileSharedUnitJoinBloc, ProfileSharedUnitJoinState>(
    'emits failure when join shared unit fails',
    build: () {
      when(
        () => homeUnitsRepository.joinSharedUnit(unitId: any(named: 'unitId')),
      ).thenThrow(Exception('join failed'));
      return buildBloc();
    },
    seed: () => const ProfileSharedUnitJoinState(
      units: <HomeUnitSummary>[
        HomeUnitSummary(
          unitId: 'unit-shared',
          homeId: 'home-1',
          name: 'Alex + Sam',
          unitType: HomeUnitType.shared,
          memberUserIds: <String>['user-1', 'user-2'],
        ),
      ],
      selectedUnitId: 'unit-shared',
      status: ProfileSharedUnitJoinStatus.ready,
    ),
    act: (bloc) => bloc.add(const ProfileSharedUnitJoinSubmitted()),
    expect: () => const [
      ProfileSharedUnitJoinState(
        units: <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
        selectedUnitId: 'unit-shared',
        status: ProfileSharedUnitJoinStatus.submitting,
      ),
      ProfileSharedUnitJoinState(
        units: <HomeUnitSummary>[
          HomeUnitSummary(
            unitId: 'unit-shared',
            homeId: 'home-1',
            name: 'Alex + Sam',
            unitType: HomeUnitType.shared,
            memberUserIds: <String>['user-1', 'user-2'],
          ),
        ],
        selectedUnitId: 'unit-shared',
        status: ProfileSharedUnitJoinStatus.failure,
        errorMessage: 'Exception: join failed',
      ),
    ],
  );
}
