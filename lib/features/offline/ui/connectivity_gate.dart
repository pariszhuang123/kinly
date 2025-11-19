import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/connectivity_monitor.dart';
import '../bloc/connectivity_cubit.dart';
import 'offline_splash.dart';

class ConnectivityGate extends StatelessWidget {
  const ConnectivityGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (ConnectivityCubit cubit) => cubit.state.status,
    );
    if (status == ConnectivityStatus.offline) {
      return OfflineSplash(
        onRetry: () => context.read<ConnectivityCubit>().retry(),
      );
    }
    return child;
  }
}
