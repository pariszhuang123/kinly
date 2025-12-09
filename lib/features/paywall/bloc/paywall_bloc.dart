import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/paywall/paywall_models.dart';
import '../../../core/paywall/enums/paywall_event_type.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/paywall_repository.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  static const _premiumEntitlementId = 'kinly_premium';

  PaywallBloc({
    required PaywallRepository paywallRepository,
    required RevenueCatService revenueCatService,
    required AuthRepository authRepository,
    required String homeId,
    String? placementId,
  }) : _paywallRepository = paywallRepository,
       _revenueCatService = revenueCatService,
       _authRepository = authRepository,
       _homeId = homeId,
       _placementId = placementId,
       super(const PaywallState.initial()) {
    on<PaywallStarted>(_onStarted);
    on<PaywallCtaPressed>(_onCta);
    on<PaywallRestorePressed>(_onRestore);
    on<PaywallDismissed>(_onDismissed);
  }

  final PaywallRepository _paywallRepository;
  final RevenueCatService _revenueCatService;
  final AuthRepository _authRepository;
  final String _homeId;
  final String? _placementId;

  Future<void> _onStarted(
    PaywallStarted event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(status: PaywallLoadStatus.loading, error: null));
    try {
      RevenueCatPackage? pkg;
      try {
        pkg = await _revenueCatService.fetchMonthlyPackage(
          placementId: _placementId,
        );
      } catch (_) {
        pkg = null;
      }

      try {
        await _logEvent(PaywallEventType.impression, event.source);
      } catch (_) {
        // Ignore telemetry errors to avoid blocking UI
      }

      emit(
        state.copyWith(
          status: PaywallLoadStatus.ready,
          paywallStatus: null,
          package: pkg,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PaywallLoadStatus.error, error: '$e'));
    }
  }

  Future<void> _onCta(
    PaywallCtaPressed event,
    Emitter<PaywallState> emit,
  ) async {
    if (state.isActionInFlight) return;
    try {
      await _logEvent(PaywallEventType.ctaClick, event.source);
    } catch (_) {}
    final userId = _authRepository.current?.userId;
    emit(
      state.copyWith(actionStatus: PaywallActionStatus.purchasing, error: null),
    );
    try {
      if (userId != null) {
        await _revenueCatService.setSubscriberAttributes(
          appUserId: userId,
          homeId: _homeId,
          locale: event.locale,
          email: event.email,
        );
      }
      final pkg =
          state.package ??
          await _revenueCatService.fetchMonthlyPackage(
            placementId: _placementId,
          );
      if (pkg == null) {
        throw Exception(
          'Monthly package unavailable. Check RevenueCat offering configuration.',
        );
      }
      await _revenueCatService.purchaseMonthly(pkg);
      await _ensureEntitlementActive();
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      final isCancelled = code == PurchasesErrorCode.purchaseCancelledError;
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: isCancelled ? null : '$e',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(actionStatus: PaywallActionStatus.idle, error: '$e'),
      );
    }
  }

  Future<void> _onRestore(
    PaywallRestorePressed event,
    Emitter<PaywallState> emit,
  ) async {
    if (state.isActionInFlight) return;
    try {
      await _logEvent(PaywallEventType.restoreAttempt, event.source);
    } catch (_) {}
    emit(
      state.copyWith(actionStatus: PaywallActionStatus.restoring, error: null),
    );
    try {
      await _revenueCatService.restorePurchases();
      await _ensureEntitlementActive();
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      final isCancelled = code == PurchasesErrorCode.purchaseCancelledError;
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: isCancelled ? null : '$e',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(actionStatus: PaywallActionStatus.idle, error: '$e'),
      );
    }
  }

  Future<void> _onDismissed(
    PaywallDismissed event,
    Emitter<PaywallState> emit,
  ) async {
    try {
      await _logEvent(PaywallEventType.dismiss, event.source);
    } catch (_) {}
  }

  Future<void> _logEvent(PaywallEventType type, String? source) {
    return _paywallRepository.logEvent(
      homeId: _homeId,
      eventType: type,
      source: source,
    );
  }

  Future<void> _ensureEntitlementActive() async {
    final active =
        await _revenueCatService.isEntitlementActive(_premiumEntitlementId);
    if (!active) {
      throw Exception('Premium entitlement inactive after purchase');
    }
  }
}
