import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chores_repository.dart';
import '../bloc/flow_list_bloc.dart';
import 'flow_list_screen.dart';

class FlowListProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;

  const FlowListProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              FlowListBloc(homeId: homeId, choresRepository: choresRepository)
                ..add(const FlowListRequested()),
      child: const FlowListScreen(),
    );
  }
}
