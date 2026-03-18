import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/features/personal_directory/bloc/personal_directory_bloc.dart';

class PersonalDirectoryProvider extends StatelessWidget {
  const PersonalDirectoryProvider({
    super.key,
    required this.repository,
    required this.target,
    required this.currentUserId,
    this.homeId,
    required this.child,
  });

  final PersonalDirectoryRepository repository;
  final PersonalDirectoryMemberSummary target;
  final String currentUserId;
  final String? homeId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PersonalDirectoryBloc(
            repository: repository,
            target: target,
            currentUserId: currentUserId,
            homeId: homeId,
          ),
      child: child,
    );
  }
}
