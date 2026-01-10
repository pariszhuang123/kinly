import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../core/ui/kinly_icon_button.dart';
import '../../../core/ui/kinly_icons.dart';
import '../bloc/auth_bloc.dart';

class AuthSignOutButton extends StatelessWidget {
  const AuthSignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isBusy = context.select((AuthBloc bloc) => bloc.state.isLoading);
    return KinlyIconButton(
      icon: KinlyIcons.logout,
      tooltip: S.of(context).logout,
      onPressed:
          isBusy
              ? null
              : () {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              },
    );
  }
}
