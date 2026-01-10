import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'bloc/profile_identity_bloc.dart';
import 'profile_identity_screen.dart';

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
