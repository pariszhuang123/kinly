import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/contracts/homes/shopping_photo_capture.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/core/ui/paywall/paywall_gate.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/foundation/surfaces/today/shopping/bloc/shopping_item_bloc.dart';

class _MockShoppingListRepository extends Mock
    implements ShoppingListRepository {}

void main() {
  late _MockShoppingListRepository shoppingListRepository;

  const homeId = 'home-1';

  ShoppingListItem testItem({
    required String id,
    String name = 'Milk',
    String? quantity = '2',
    String? details = 'Whole milk',
    String? photoPath,
  }) {
    return ShoppingListItem(
      id: id,
      homeId: homeId,
      name: name,
      quantity: quantity,
      details: details,
      referencePhotoPath: photoPath,
      isCompleted: false,
      completedByUserId: null,
      completedByAvatarId: null,
      completedAt: null,
      archivedAt: null,
      createdAt: DateTime(2026, 2, 1, 9),
      updatedAt: DateTime(2026, 2, 1, 10),
    );
  }

  ShoppingItemBloc buildBloc({ShoppingListItem? item}) {
    return ShoppingItemBloc(
      homeId: homeId,
      item: item,
      shoppingListRepository: shoppingListRepository,
    );
  }

  setUpAll(() {
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    shoppingListRepository = _MockShoppingListRepository();
    when(() => shoppingListRepository.toPublicPhotoUrl(any())).thenAnswer((
      invocation,
    ) {
      final path = invocation.positionalArguments.first as String?;
      if (path == null || path.isEmpty) return null;
      return 'https://cdn.example/$path';
    });
    when(
      () => shoppingListRepository.isPhotoLimitError(any()),
    ).thenReturn(false);
    when(
      () => shoppingListRepository.captureAndUploadPhoto(
        homeId: any(named: 'homeId'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => shoppingListRepository.addItem(
        homeId: any(named: 'homeId'),
        name: any(named: 'name'),
        quantity: any(named: 'quantity'),
        details: any(named: 'details'),
        referencePhotoPath: any(named: 'referencePhotoPath'),
      ),
    ).thenAnswer(
      (_) async => testItem(
        id: 'created-1',
        name: 'Bread',
        quantity: null,
        details: null,
      ),
    );
    when(
      () => shoppingListRepository.updateItem(
        itemId: any(named: 'itemId'),
        name: any(named: 'name'),
        quantity: any(named: 'quantity'),
        details: any(named: 'details'),
        isCompleted: any(named: 'isCompleted'),
        referencePhotoPath: any(named: 'referencePhotoPath'),
        replacePhoto: any(named: 'replacePhoto'),
      ),
    ).thenAnswer((_) async => testItem(id: 'updated-1'));
    when(
      () => shoppingListRepository.archiveItemsForUser(
        homeId: any(named: 'homeId'),
        itemIds: any(named: 'itemIds'),
      ),
    ).thenAnswer((_) async => 1);
  });

  group('ShoppingItemBloc', () {
    test('initial state hydrates from edit item', () {
      final existing = testItem(
        id: 'item-1',
        photoPath: 'households/photo.jpg',
      );
      final bloc = buildBloc(item: existing);

      expect(bloc.state.isEditing, isTrue);
      expect(bloc.state.name, 'Milk');
      expect(bloc.state.quantity, '2');
      expect(bloc.state.details, 'Whole milk');
      expect(bloc.state.referencePhotoPath, 'households/photo.jpg');
      expect(
        bloc.state.referencePhotoUrl,
        'https://cdn.example/households/photo.jpg',
      );

      bloc.close();
    });

    blocTest<ShoppingItemBloc, ShoppingItemState>(
      'shows validation when submitting empty name',
      build: buildBloc,
      act: (bloc) => bloc.add(const SubmitShoppingItemEvent()),
      expect:
          () => [
            isA<ShoppingItemState>().having(
              (s) => s.showValidationErrors,
              'showValidationErrors',
              true,
            ),
          ],
      verify: (_) {
        verifyNever(
          () => shoppingListRepository.addItem(
            homeId: any(named: 'homeId'),
            name: any(named: 'name'),
            quantity: any(named: 'quantity'),
            details: any(named: 'details'),
            referencePhotoPath: any(named: 'referencePhotoPath'),
          ),
        );
      },
    );

    blocTest<ShoppingItemBloc, ShoppingItemState>(
      'submits add-item with trimmed optional fields',
      build: buildBloc,
      act: (bloc) {
        bloc
          ..add(const ShoppingItemNameChangedEvent('  Bread  '))
          ..add(const ShoppingItemQuantityChangedEvent('  '))
          ..add(const ShoppingItemDetailsChangedEvent('  bakery  '))
          ..add(const SubmitShoppingItemEvent());
      },
      expect:
          () => [
            isA<ShoppingItemState>().having((s) => s.name, 'name', '  Bread  '),
            isA<ShoppingItemState>().having(
              (s) => s.quantity,
              'quantity',
              '  ',
            ),
            isA<ShoppingItemState>().having(
              (s) => s.details,
              'details',
              '  bakery  ',
            ),
            isA<ShoppingItemState>()
                .having((s) => s.isSubmitting, 'isSubmitting', true)
                .having(
                  (s) => s.showValidationErrors,
                  'showValidationErrors',
                  true,
                ),
            isA<ShoppingItemState>()
                .having((s) => s.isSubmitting, 'isSubmitting', false)
                .having((s) => s.successItemId, 'successItemId', 'created-1')
                .having(
                  (s) => s.showValidationErrors,
                  'showValidationErrors',
                  false,
                ),
          ],
      verify: (_) {
        verify(
          () => shoppingListRepository.addItem(
            homeId: homeId,
            name: 'Bread',
            quantity: null,
            details: 'bakery',
            referencePhotoPath: null,
          ),
        ).called(1);
      },
    );

    blocTest<ShoppingItemBloc, ShoppingItemState>(
      'handles permission error when uploading photo',
      build: buildBloc,
      setUp: () {
        when(
          () => shoppingListRepository.captureAndUploadPhoto(homeId: homeId),
        ).thenThrow(
          const ShoppingPhotoCaptureException(
            kind: ShoppingPhotoCaptureErrorKind.permission,
            message: 'permission',
            permanentlyDenied: true,
          ),
        );
      },
      act: (bloc) => bloc.add(const ShoppingItemPhotoCaptureRequestedEvent()),
      expect:
          () => [
            isA<ShoppingItemState>().having(
              (s) => s.isUploadingPhoto,
              'uploading',
              true,
            ),
            isA<ShoppingItemState>()
                .having((s) => s.isUploadingPhoto, 'uploading', false)
                .having(
                  (s) => s.photoErrorMessage,
                  'photoErrorMessage',
                  'permission',
                )
                .having(
                  (s) => s.cameraPermissionPermanentlyDenied,
                  'cameraPermissionPermanentlyDenied',
                  true,
                )
                .having((s) => s.photoErrorTick, 'photoErrorTick', 1),
          ],
    );

    blocTest<ShoppingItemBloc, ShoppingItemState>(
      'requests paywall on photo cap error and retries after grant',
      build: buildBloc,
      setUp: () {
        var attempts = 0;
        when(
          () => shoppingListRepository.addItem(
            homeId: any(named: 'homeId'),
            name: any(named: 'name'),
            quantity: any(named: 'quantity'),
            details: any(named: 'details'),
            referencePhotoPath: any(named: 'referencePhotoPath'),
          ),
        ).thenAnswer((_) async {
          attempts += 1;
          if (attempts == 1) {
            throw const ShoppingListException(
              ShoppingListErrorCode.paywallShoppingItemPhotosCap,
              'cap reached',
            );
          }
          return testItem(id: 'created-after-paywall', name: 'Eggs');
        });
        when(() => shoppingListRepository.isPhotoLimitError(any())).thenAnswer(
          (invocation) =>
              invocation.positionalArguments.first is ShoppingListException,
        );
      },
      act: (bloc) {
        bloc
          ..add(const ShoppingItemNameChangedEvent('Eggs'))
          ..add(const SubmitShoppingItemEvent())
          ..add(
            const ShoppingItemPaywallResolvedEvent(
              PaywallGateOutcome(
                requestId: 'req-1',
                action: PaywallRetryAction.submit,
                status: PaywallGateStatus.granted,
              ),
            ),
          );
      },
      expect:
          () => [
            isA<ShoppingItemState>().having((s) => s.name, 'name', 'Eggs'),
            isA<ShoppingItemState>().having(
              (s) => s.isSubmitting,
              'isSubmitting',
              true,
            ),
            isA<ShoppingItemState>()
                .having((s) => s.isSubmitting, 'isSubmitting', false)
                .having((s) => s.paywallRequestTick, 'paywallRequestTick', 1)
                .having(
                  (s) => s.paywallAction,
                  'paywallAction',
                  PaywallRetryAction.submit,
                )
                .having((s) => s.paywallRequest, 'paywallRequest', isNotNull),
            isA<ShoppingItemState>().having(
              (s) => s.isSubmitting,
              'isSubmitting',
              true,
            ),
            isA<ShoppingItemState>()
                .having((s) => s.isSubmitting, 'isSubmitting', false)
                .having(
                  (s) => s.successItemId,
                  'successItemId',
                  'created-after-paywall',
                ),
          ],
    );

    blocTest<ShoppingItemBloc, ShoppingItemState>(
      'archives item on delete for edit flow',
      build: () => buildBloc(item: testItem(id: 'item-delete')),
      act: (bloc) => bloc.add(const DeleteShoppingItemEvent()),
      expect:
          () => [
            isA<ShoppingItemState>().having(
              (s) => s.isSubmitting,
              'isSubmitting',
              true,
            ),
            isA<ShoppingItemState>()
                .having((s) => s.isSubmitting, 'isSubmitting', false)
                .having((s) => s.successItemId, 'successItemId', 'item-delete'),
          ],
      verify: (_) {
        verify(
          () => shoppingListRepository.archiveItemsForUser(
            homeId: homeId,
            itemIds: ['item-delete'],
          ),
        ).called(1);
      },
    );
  });
}
