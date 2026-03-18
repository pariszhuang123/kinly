import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockHouseDirectoryRepository extends Mock
    implements HouseDirectoryRepository {}

void main() {
  late _MockHouseDirectoryRepository repository;

  setUp(() {
    repository = _MockHouseDirectoryRepository();
  });

  HouseDirectoryWifi buildWifi() {
    final now = DateTime(2026, 3, 13);
    return HouseDirectoryWifi(
      id: 'wifi-1',
      homeId: 'home-1',
      ssid: 'Kinly Wifi',
      qrPayload: 'WIFI:T:WPA;S:Kinly Wifi;P:test;;',
      createdAt: now,
      updatedAt: now,
    );
  }

  HouseDirectoryContent buildContent() {
    final now = DateTime(2026, 3, 13);
    return HouseDirectoryContent(
      services: [
        HouseDirectoryService(
          id: 'service-1',
          homeId: 'home-1',
          serviceType: HouseDirectoryServiceType.rent,
          providerName: 'Landlord',
          createdAt: now,
          updatedAt: now,
        ),
      ],
      notes: const [],
    );
  }

  HouseDirectoryReminder buildReminder() {
    return HouseDirectoryReminder(
      id: 'reminder-1',
      serviceId: 'service-1',
      kind: HouseDirectoryReminderKind.renewal,
      status: HouseDirectoryReminderStatus.active,
      termStartDate: DateTime(2026, 1, 1),
      termEndDate: DateTime(2026, 12, 31),
      dueAt: DateTime(2026, 9, 30),
      providerName: 'Landlord',
      serviceType: HouseDirectoryServiceType.rent,
    );
  }

  group('HouseDirectoryBloc', () {
    blocTest<HouseDirectoryBloc, HouseDirectoryState>(
      'loads wifi, content, and reminders on start',
      build: () {
        when(
          () => repository.getWifi(homeId: 'home-1'),
        ).thenAnswer((_) async => buildWifi());
        when(
          () => repository.getContent(homeId: 'home-1'),
        ).thenAnswer((_) async => buildContent());
        when(
          () => repository.listDueReminders(homeId: 'home-1'),
        ).thenAnswer((_) async => [buildReminder()]);
      when(() => repository.getMemberCards()).thenAnswer((_) async => const []);
        return HouseDirectoryBloc(
          repository: repository,
          homeId: 'home-1',
          isOwner: true,
        );
      },
      expect:
          () => [
            isA<HouseDirectoryState>().having(
              (state) => state.status,
              'status',
              HouseDirectoryStatus.loading,
            ),
            isA<HouseDirectoryState>()
                .having(
                  (state) => state.status,
                  'status',
                  HouseDirectoryStatus.success,
                )
                .having((state) => state.wifi?.ssid, 'wifi', 'Kinly Wifi')
                .having(
                  (state) => state.services.length,
                  'services',
                  1,
                )
                .having(
                  (state) => state.reminders.length,
                  'reminders',
                  1,
                ),
          ],
    );
  });
}
