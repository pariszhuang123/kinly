import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_bank_screen.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_note_screen.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_provider.dart';
import 'package:kinly/features/personal_directory/ui/personal_directory_screen.dart';

class PersonalDirectoryRouteContext {
  const PersonalDirectoryRouteContext({
    required this.currentUserId,
    this.homeId,
  });

  final String currentUserId;
  final String? homeId;
}

typedef PersonalDirectoryRouteContextResolver =
    PersonalDirectoryRouteContext? Function();

List<GoRoute> buildPersonalDirectoryRoutes({
  required PersonalDirectoryRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.personalDirectory,
      name: AppRouteNames.personalDirectory,
      builder: (_, state) {
        final routeContext = resolveContext();
        final target = _resolveTarget(
          extra: state.extra,
          routeContext: routeContext,
        );
        if (routeContext == null || target == null) {
          return routeFallback(
            'personalDirectory',
            state: state,
            reason: 'target user unavailable while route restores',
          );
        }
        return PersonalDirectoryProvider(
          repository: sl<PersonalDirectoryRepository>(),
          target: target,
          currentUserId: routeContext.currentUserId,
          homeId: routeContext.homeId,
          child: const PersonalDirectoryScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.personalDirectoryBank,
      name: AppRouteNames.personalDirectoryBank,
      builder: (_, state) {
        final args = state.extra as PersonalDirectoryBankRouteArgs?;
        if (args == null) {
          return routeFallback(
            'personalDirectoryBank',
            state: state,
            reason: 'PersonalDirectoryBankRouteArgs missing in state.extra',
          );
        }
        return PersonalDirectoryBankScreen(
          repository: sl<PersonalDirectoryRepository>(),
          initial: args.initial,
          canEdit: args.canEdit,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.personalDirectoryNote,
      name: AppRouteNames.personalDirectoryNote,
      builder: (_, state) {
        final args = state.extra as PersonalDirectoryNoteRouteArgs?;
        if (args == null) {
          return routeFallback(
            'personalDirectoryNote',
            state: state,
            reason: 'PersonalDirectoryNoteRouteArgs missing in state.extra',
          );
        }
        return PersonalDirectoryNoteScreen(
          repository: sl<PersonalDirectoryRepository>(),
          note: args.note,
          canEdit: args.canEdit,
          availableNoteTypes: args.availableNoteTypes,
        );
      },
    ),
  ];
}

PersonalDirectoryMemberSummary? _resolveTarget({
  required Object? extra,
  required PersonalDirectoryRouteContext? routeContext,
}) {
  if (extra is PersonalDirectoryMemberSummary) return extra;
  if (routeContext == null) return null;
  return PersonalDirectoryMemberSummary(
    userId: routeContext.currentUserId,
    username: '',
    isHomeOwner: false,
  );
}
