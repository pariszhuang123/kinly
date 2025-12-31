import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../profile_settings.dart';
import 'bloc/profile_identity_bloc.dart';
import 'profile_identity_screen.dart';

class ProfileIdentityRouteArgs {
  const ProfileIdentityRouteArgs({
    required this.homeId,
    this.initialUsername,
    this.initialAvatarStoragePath,
    this.initialAvatarUrl,
  });

  final String homeId;
  final String? initialUsername;
  final String? initialAvatarStoragePath;
  final String? initialAvatarUrl;
}

class ProfileIdentityProvider extends StatelessWidget {
  ProfileIdentityProvider({
    super.key,
    required this.homeId,
    this.initialUsername,
    this.initialAvatarStoragePath,
    this.initialAvatarUrl,
    ProfileRepository? profileRepository,
  }) : _profileRepository = profileRepository ?? sl<ProfileRepository>();

  final String homeId;
  final String? initialUsername;
  final String? initialAvatarStoragePath;
  final String? initialAvatarUrl;
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
      child: const ProfileIdentityScreen(),
    );
  }
}
