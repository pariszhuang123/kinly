import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/di/locator.dart';

import 'bloc/profile_shared_unit_create_bloc.dart';
import 'profile_shared_unit_create_screen.dart';

class ProfileSharedUnitCreateProvider extends StatelessWidget {
  ProfileSharedUnitCreateProvider({
    super.key,
    required this.homeId,
    required this.creatorMembershipId,
    HomeUnitsRepository? homeUnitsRepository,
  }) : _homeUnitsRepository = homeUnitsRepository ?? sl<HomeUnitsRepository>();

  final String homeId;
  final String creatorMembershipId;
  final HomeUnitsRepository _homeUnitsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSharedUnitCreateBloc(
        homeUnitsRepository: _homeUnitsRepository,
        homeId: homeId,
        creatorMembershipId: creatorMembershipId,
      )..add(const ProfileSharedUnitCreateStarted()),
      child: const ProfileSharedUnitCreateScreen(),
    );
  }
}
