import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';

class HouseDirectoryProvider extends StatelessWidget {
  const HouseDirectoryProvider({
    super.key,
    required this.repository,
    required this.homeId,
    required this.isOwner,
    required this.child,
  });

  final HouseDirectoryRepository repository;
  final String homeId;
  final bool isOwner;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HouseDirectoryBloc(
            repository: repository,
            homeId: homeId,
            isOwner: isOwner,
          ),
      child: child,
    );
  }
}
