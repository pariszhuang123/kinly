import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';
import 'house_norm_edit_screen.dart';

class HouseNormEditProvider extends StatelessWidget {
  const HouseNormEditProvider({
    super.key,
    required this.homeId,
    required this.locale,
    required this.isOwner,
    required this.repository,
  });

  final String homeId;
  final String locale;
  final bool isOwner;
  final HouseNormsRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HouseNormReportCubit(
            repository: repository,
            homeId: homeId,
            locale: locale,
            isOwner: isOwner,
          )..load(),
      child: HouseNormEditScreen(canEdit: isOwner),
    );
  }
}
