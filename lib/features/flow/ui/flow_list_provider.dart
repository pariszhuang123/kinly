import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/flow/enums/flow_list_filter.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../bloc/flow_list_bloc.dart';
import 'flow_list_screen.dart';

class FlowListProvider extends StatelessWidget {
  final String homeId;
  final ChoresRepository choresRepository;
  final HomeRepository homeRepository;
  final FlowListFilter filter;
  final String currentUserId;
  final bool showOnlyCurrentUser;

  const FlowListProvider({
    super.key,
    required this.homeId,
    required this.choresRepository,
    required this.homeRepository,
    required this.currentUserId,
    this.filter = FlowListFilter.all,
    this.showOnlyCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FlowListBloc(
            homeId: homeId,
            choresRepository: choresRepository,
            homeRepository: homeRepository,
          )..add(const FlowListRequested()),
      child: FlowListScreen(
        filter: filter,
        currentUserId: currentUserId,
        showOnlyCurrentUser: showOnlyCurrentUser,
      ),
    );
  }
}
