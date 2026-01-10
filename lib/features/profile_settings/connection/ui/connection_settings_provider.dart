import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/notifications.dart';
import '../bloc/connection_settings_bloc.dart';
import 'connection_settings_screen.dart';

class ConnectionSettingsProvider extends StatelessWidget {
  ConnectionSettingsProvider({
    super.key,
    NotificationsRepository? notificationsRepository,
    NotificationPermissionService? permissionService,
  }) : _notificationsRepository =
           notificationsRepository ?? sl<NotificationsRepository>(),
       _permissionService =
           permissionService ??
           NotificationPermissionService(
             notificationsRepository:
                 notificationsRepository ?? sl<NotificationsRepository>(),
           );

  final NotificationsRepository _notificationsRepository;
  final NotificationPermissionService _permissionService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ConnectionSettingsBloc(
            notificationsRepository: _notificationsRepository,
            permissionService: _permissionService,
          ),
      child: const ConnectionSettingsScreen(),
    );
  }
}
