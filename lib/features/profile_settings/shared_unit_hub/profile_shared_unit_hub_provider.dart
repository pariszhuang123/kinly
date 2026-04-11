import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/di/locator.dart';

import 'bloc/profile_shared_unit_hub_bloc.dart';
import 'profile_shared_unit_hub_screen.dart';

class ProfileSharedUnitHubProvider extends StatelessWidget {
  ProfileSharedUnitHubProvider({
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
      create: (_) => ProfileSharedUnitHubBloc(
        homeUnitsRepository: _homeUnitsRepository,
        homeId: homeId,
      )..add(const ProfileSharedUnitHubStarted()),
      child: ProfileSharedUnitHubScreen(
        homeId: homeId,
        creatorMembershipId: creatorMembershipId,
      ),
    );
  }
}
