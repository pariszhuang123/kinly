import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/account/ports/account_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'bloc/profile_settings_bloc.dart';
import 'profile_surface.dart';

class ProfileSettingsProvider extends StatelessWidget {
  ProfileSettingsProvider({
    super.key,
    required this.homeId,
    this.initialDisplayName,
    this.initialAvatarUrl,
    this.onMembershipRefresh,
    this.onSignOut,
    ProfileRepository? profileRepository,
    HomeRepository? homeRepository,
    HomeUnitsRepository? homeUnitsRepository,
    AccountRepository? accountRepository,
  }) : _profileRepository = profileRepository ?? sl<ProfileRepository>(),
       _homeRepository = homeRepository ?? sl<HomeRepository>(),
       _homeUnitsRepository =
           homeUnitsRepository ?? sl<HomeUnitsRepository>(),
       _accountRepository = accountRepository ?? sl<AccountRepository>();

  final String homeId;
  final String? initialDisplayName;
  final String? initialAvatarUrl;
  final VoidCallback? onMembershipRefresh;
  final VoidCallback? onSignOut;
  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;
  final HomeUnitsRepository _homeUnitsRepository;
  final AccountRepository _accountRepository;

  @override
  Widget build(BuildContext context) {
    final initialUser =
        initialDisplayName == null && initialAvatarUrl == null
            ? null
            : ProfileSettingsUser(
              displayName: initialDisplayName ?? '',
              avatarUrl: initialAvatarUrl,
            );

    return BlocProvider(
      create:
          (_) => ProfileSettingsBloc(
            profileRepository: _profileRepository,
            homeRepository: _homeRepository,
            homeUnitsRepository: _homeUnitsRepository,
            accountRepository: _accountRepository,
            homeId: homeId,
            initialUser: initialUser,
          )..add(const ProfileSettingsStarted()),
      child: ProfileSettingsScreen(
        onMembershipRefresh: onMembershipRefresh ?? () {},
        onSignOut: onSignOut ?? () {},
      ),
    );
  }
}
