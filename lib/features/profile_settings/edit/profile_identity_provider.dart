import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'bloc/profile_identity_bloc.dart';
import 'profile_identity_screen.dart';

class ProfileIdentityProvider extends StatelessWidget {
  ProfileIdentityProvider({
    super.key,
    required this.homeId,
    this.creatorMembershipId,
    this.initialUsername,
    this.initialAvatarStoragePath,
    this.initialAvatarUrl,
    HomeRepository? homeRepository,
    ProfileRepository? profileRepository,
  }) : _homeRepository = homeRepository ?? sl<HomeRepository>(),
       _profileRepository = profileRepository ?? sl<ProfileRepository>();

  final String homeId;
  final String? creatorMembershipId;
  final String? initialUsername;
  final String? initialAvatarStoragePath;
  final String? initialAvatarUrl;
  final HomeRepository _homeRepository;
  final ProfileRepository _profileRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ProfileIdentityBloc(
            profileRepository: _profileRepository,
            homeId: homeId,
            initialUsername: initialUsername,
            initialAvatarStoragePath: initialAvatarStoragePath,
            initialAvatarUrl: initialAvatarUrl,
          )..add(const ProfileIdentityStarted()),
      child: ProfileIdentityScreen(
        homeId: homeId,
        creatorMembershipId: creatorMembershipId,
        homeRepository: _homeRepository,
      ),
    );
  }
}
