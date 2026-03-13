import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_screen.dart';

class HouseDirectoryProvider extends StatelessWidget {
  const HouseDirectoryProvider({
    super.key,
    required this.repository,
    required this.homeId,
    required this.isOwner,
  });

  final HouseDirectoryRepository repository;
  final String homeId;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => HouseDirectoryBloc(
            repository: repository,
            homeId: homeId,
            isOwner: isOwner,
          ),
      child: HouseDirectoryScreen(homeId: homeId),
    );
  }
}
