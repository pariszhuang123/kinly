import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/core/di/locator.dart';

import 'bloc/profile_shared_unit_rename_bloc.dart';
import 'profile_shared_unit_rename_screen.dart';

class ProfileSharedUnitRenameProvider extends StatelessWidget {
  ProfileSharedUnitRenameProvider({
    super.key,
    required this.unitId,
    required this.initialName,
    HomeUnitsRepository? homeUnitsRepository,
  }) : _homeUnitsRepository = homeUnitsRepository ?? sl<HomeUnitsRepository>();

  final String unitId;
  final String initialName;
  final HomeUnitsRepository _homeUnitsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSharedUnitRenameBloc(
        homeUnitsRepository: _homeUnitsRepository,
        unitId: unitId,
        initialName: initialName,
      ),
      child: const ProfileSharedUnitRenameScreen(),
    );
  }
}
