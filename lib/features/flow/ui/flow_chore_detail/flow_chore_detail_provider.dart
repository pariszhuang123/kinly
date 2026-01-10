import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/features/flow/flow.dart';
import '../../bloc/flow_chore_detail_bloc.dart';
import 'flow_chore_detail_screen.dart';

class FlowChoreDetailProvider extends StatelessWidget {
  const FlowChoreDetailProvider({
    super.key,
    required this.homeId,
    required this.choreId,
    required this.choresRepository,
  });

  final String homeId;
  final String choreId;
  final ChoresRepository choresRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FlowChoreDetailBloc(
            homeId: homeId,
            choreId: choreId,
            choresRepository: choresRepository,
          )..add(const FlowChoreDetailStarted()),
      child: const FlowChoreDetailScreen(),
    );
  }
}
