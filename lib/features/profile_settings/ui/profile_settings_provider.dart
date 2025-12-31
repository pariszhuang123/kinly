import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../../../core/account/account.dart';
import '../../../../features/home/home.dart';
import '../../../data/repositories/profile_repository.dart';
import '../bloc/profile_settings_bloc.dart';
import 'profile_settings_screen.dart';

class ProfileSettingsRouteArgs {
  const ProfileSettingsRouteArgs({
    required this.homeId,
    this.displayName,
    this.avatarUrl,
  });

  final String homeId;
  final String? displayName;
  final String? avatarUrl;
}

class ProfileSettingsProvider extends StatelessWidget {
  ProfileSettingsProvider({
    super.key,
    required this.homeId,
    this.initialDisplayName,
    this.initialAvatarUrl,
    ProfileRepository? profileRepository,
    HomeRepository? homeRepository,
    AccountRepository? accountRepository,
  }) : _profileRepository = profileRepository ?? sl<ProfileRepository>(),
       _homeRepository = homeRepository ?? sl<HomeRepository>(),
       _accountRepository = accountRepository ?? sl<AccountRepository>();

  final String homeId;
  final String? initialDisplayName;
  final String? initialAvatarUrl;
  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;
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
            accountRepository: _accountRepository,
            homeId: homeId,
            initialUser: initialUser,
          )..add(const ProfileSettingsStarted()),
      child: const ProfileSettingsScreen(),
    );
  }
}
