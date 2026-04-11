import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/di/locator.dart';

import 'bloc/profile_shared_unit_join_bloc.dart';
import 'profile_shared_unit_join_screen.dart';

class ProfileSharedUnitJoinProvider extends StatelessWidget {
  ProfileSharedUnitJoinProvider({
    super.key,
    required this.homeId,
    HomeUnitsRepository? homeUnitsRepository,
  }) : _homeUnitsRepository = homeUnitsRepository ?? sl<HomeUnitsRepository>();

  final String homeId;
  final HomeUnitsRepository _homeUnitsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSharedUnitJoinBloc(
        homeUnitsRepository: _homeUnitsRepository,
        homeId: homeId,
      )..add(const ProfileSharedUnitJoinStarted()),
      child: const ProfileSharedUnitJoinScreen(),
    );
  }
}
