import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/data/repositories/app_version_repository.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';

class _MockAppVersionRepository extends Mock
    implements AppVersionRepository {}

void main() {
  late _MockAppVersionRepository repository;

  setUp(() {
    repository = _MockAppVersionRepository();
  });

  blocTest<AppVersionCubit, AppVersionState>(
    'emits upToDate when server reports no update',
    build: () {
      when(
        () => repository.checkVersion(clientVersion: any(named: 'clientVersion')),
      ).thenAnswer(
        (_) async => const AppVersionStatusResult(
          clientVersion: '1.0.0',
          currentVersion: '1.0.0',
          minSupportedVersion: '1.0.0',
          hardBlocked: false,
          updateRecommended: false,
        ),
      );
      return AppVersionCubit(repository: repository);
    },
    act: (cubit) => cubit.checkForUpdates(clientVersion: '1.0.0'),
    expect: () => [
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.checking,
      ),
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.upToDate,
      ),
    ],
  );

  blocTest<AppVersionCubit, AppVersionState>(
    'emits hardBlocked when RPC says so',
    build: () {
      when(
        () => repository.checkVersion(clientVersion: any(named: 'clientVersion')),
      ).thenAnswer(
        (_) async => const AppVersionStatusResult(
          clientVersion: '1.0.0',
          currentVersion: '1.2.0',
          minSupportedVersion: '1.1.0',
          hardBlocked: true,
          updateRecommended: false,
        ),
      );
      return AppVersionCubit(repository: repository);
    },
    act: (cubit) => cubit.checkForUpdates(clientVersion: '1.0.0'),
    expect: () => [
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.checking,
      ),
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.hardBlocked,
      ),
    ],
  );

  blocTest<AppVersionCubit, AppVersionState>(
    'emits failed when repository throws',
    build: () {
      when(
        () => repository.checkVersion(clientVersion: any(named: 'clientVersion')),
      ).thenThrow(Exception('network error'));
      return AppVersionCubit(repository: repository);
    },
    act: (cubit) => cubit.checkForUpdates(clientVersion: '1.0.0'),
    expect: () => [
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.checking,
      ),
      isA<AppVersionState>().having(
        (state) => state.status,
        'status',
        AppVersionStatus.failed,
      ),
    ],
  );
}
