import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../share/share.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';
import 'share_created_list_screen.dart';

class ShareCreatedListProvider extends StatelessWidget {
  const ShareCreatedListProvider({
    super.key,
    required this.homeId,
    required this.expensesRepository,
    this.draftsOnly = false,
  });

  final String homeId;
  final ExpensesRepository expensesRepository;
  final bool draftsOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ShareCreatedListBloc(
            homeId: homeId,
            expensesRepository: expensesRepository,
            draftsOnly: draftsOnly,
          )..add(const ShareCreatedListRequested()),
      child: const ShareCreatedListScreen(),
    );
  }
}
