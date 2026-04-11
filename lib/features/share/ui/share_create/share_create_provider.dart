import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/share/share_create_route_args.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../../domain/share_split_mode.dart';
import 'share_create_screen.dart';

class ShareCreateProvider extends StatelessWidget {
  const ShareCreateProvider({
    super.key,
    required this.homeId,
    required this.expensesRepository,
    required this.homeRepository,
    required this.homeUnitsRepository,
    this.routeArgs,
    this.shoppingListRepository,
  });

  final String homeId;
  final ExpensesRepository expensesRepository;
  final HomeRepository homeRepository;
  final HomeUnitsRepository homeUnitsRepository;
  final ShareCreateRouteArgs? routeArgs;
  final ShoppingListRepository? shoppingListRepository;

  @override
  Widget build(BuildContext context) {
    final initialForm =
        routeArgs == null
            ? null
            : ShareCreateForm.initial().copyWith(
              description: routeArgs?.initialDescription ?? '',
              notes: routeArgs?.initialNotes ?? '',
              splitMode:
                  routeArgs?.preselectEqualSplit == true
                      ? ShareSplitMode.equal
                      : null,
            );
    return BlocProvider(
      create:
          (_) => ShareCreateBloc(
            homeId: homeId,
            expensesRepository: expensesRepository,
            homeRepository: homeRepository,
            homeUnitsRepository: homeUnitsRepository,
            shoppingListRepository: shoppingListRepository,
            initialForm: initialForm,
            shoppingExpenseLinkRequest: routeArgs?.shoppingExpenseLinkRequest,
          )
            ..add(const ShareCreateParticipantsRequested())
            ..add(const ShareCreateEvidencePhotoRecoveryRequested()),
      child: ShareCreateScreen(
        homeId: homeId,
        presentationMode:
            routeArgs?.presentationMode ?? ShareCreatePresentationMode.standard,
      ),
    );
  }
}
