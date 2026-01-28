import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

class _MockPreferenceReportsRepository extends Mock
    implements PreferenceReportsRepository {}

class _MockHouseVibeRepository extends Mock implements HouseVibeRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue('homeId');
  });

  HubBloc buildBloc() {
    return HubBloc(
      homeRepository: _MockHomeRepository(),
      preferenceReportsRepository: _MockPreferenceReportsRepository(),
      houseVibeRepository: _MockHouseVibeRepository(),
      homeId: 'home-id',
    );
  }

  test(
    'appLink falls back to go.makinglifeeasie.com/kinly when no inviteHost',
    () {
      final bloc = buildBloc();
      expect(bloc.state.appLink, 'https://go.makinglifeeasie.com/kinly');
    },
  );
}
