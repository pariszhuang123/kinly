import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../bloc/flow_chore_bloc.dart';
import '../domain/flow_chore_form.dart';
import 'flow_chore_screen.dart';

class FlowChoreProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final HomeRepository homeRepository;
  final String? choreId;
  final FlowChoreForm? initialForm;

  const FlowChoreProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.homeRepository,
    this.choreId,
    this.initialForm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FlowChoreBloc(
            homeId: homeId,
            choreId: choreId,
            choresRepository: choresRepository,
            homeRepository: homeRepository,
            initialForm: initialForm,
          )
            ..add(const FlowChoreStarted())
            ..add(const FlowChorePhotoRecoveryRequested()),
      child: FlowChoreScreen(homeId: homeId),
    );
  }
}
