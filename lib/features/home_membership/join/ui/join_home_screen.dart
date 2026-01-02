import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/locator.dart';
import '../../../../app/router/app_router.dart';
import '../../../../contracts/homes/ports/home_repository.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/auth/widgets/auth_error_listener.dart';
import '../bloc/join_home_bloc.dart';
import 'join_home_surface_contract.dart';
import 'join_home_surface_registry.dart';

class JoinHomeScreen extends StatelessWidget {
  const JoinHomeScreen({super.key, this.initialCode});

  final String? initialCode;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: BlocProvider(
        create:
            (_) =>
                JoinHomeBloc(homeRepository: sl<HomeRepository>())
                  ..add(JoinHomeCodeChanged(initialCode ?? '')),
        child: Scaffold(
          appBar: AppBar(
            title: Text(s.join_title, style: theme.textTheme.titleLarge),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.go(AppRoutes.start),
              ),
            ],
          ),
          body: SafeArea(
            child: _buildJoinHomeBody(
              context: context,
              initialCode: initialCode ?? '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinHomeBody({
    required BuildContext context,
    required String initialCode,
  }) {
    JoinHomeRegistry.bootstrap();
    final scope = JoinHomeSurfaceScope(
      context: context,
      initialCode: initialCode,
    );
    final slots = JoinHomeSurfaceSlots(
      body: _buildJoinHomeSections(scope),
    );
    return slots.body;
  }

  Widget _buildJoinHomeSections(JoinHomeSurfaceScope scope) {
    final entries = JoinHomeRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          entries.map((entry) => entry.builder(scope)).toList(growable: false),
    );
  }
}
