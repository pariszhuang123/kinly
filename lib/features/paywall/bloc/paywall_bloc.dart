import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/logging/logger.dart';
import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/paywall/paywall_models.dart';
import '../../../core/paywall/enums/paywall_event_type.dart';
import '../../../core/paywall/enums/paywall_trigger.dart';
import '../../../core/homes/models.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/paywall/paywall.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  static const _premiumEntitlementId = 'kinly_premium';
  static const _logTag = 'PaywallBloc';

  PaywallBloc({
    required PaywallRepository paywallRepository,
    required RevenueCatService revenueCatService,
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
    required String homeId,
    required Logger logger,
    String? placementId,
  }) : _paywallRepository = paywallRepository,
       _revenueCatService = revenueCatService,
       _authRepository = authRepository,
       _homeRepository = homeRepository,
       _homeId = homeId,
       _placementId = placementId,
       _logger = logger,
       super(const PaywallState.initial()) {
    on<PaywallStarted>(_onStarted);
    on<PaywallCtaPressed>(_onCta);
    on<PaywallRestorePressed>(_onRestore);
    on<PaywallDismissed>(_onDismissed);
  }

  final PaywallRepository _paywallRepository;
  final RevenueCatService _revenueCatService;
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;
  final String _homeId;
  final Logger _logger;
  final String? _placementId;

  Future<void> _onStarted(
    PaywallStarted event,
    Emitter<PaywallState> emit,
  ) async {
    await _logStart(event);
    emit(state.copyWith(status: PaywallLoadStatus.loading, error: null));
    try {
      final pkg = await _loadMonthlyPackage();
      final members = await _loadActiveMembers();
      await _logImpressionSafe(event.source);

      emit(
        state.copyWith(
          status: PaywallLoadStatus.ready,
          paywallStatus: null,
          package: pkg,
          activeMembers: members,
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
    String? rcUserId;
    try {
      rcUserId = await Purchases.appUserID;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to read RevenueCat appUserID before purchase',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      _logger.info(
        'Purchase attempt: supabaseUser=$userId rcUserId=$rcUserId homeId=$_homeId placement=$_placementId pkg=${state.package?.identifier}',
        tag: _logTag,
      );
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
      await _logEntitlementsSnapshot(context: 'post-purchase');
      await _ensureEntitlementActive();
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      final isCancelled = code == PurchasesErrorCode.purchaseCancelledError;
      _logger.warn(
        'Purchase failed: code=$code message=${e.message} details=${e.details}',
        tag: _logTag,
        error: e,
      );
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: isCancelled ? null : '$e',
        ),
      );
    } catch (e) {
      emit(state.copyWith(actionStatus: PaywallActionStatus.idle, error: '$e'));
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
      await _logEntitlementsSnapshot(context: 'post-restore');
      await _ensureEntitlementActive();
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      final isCancelled = code == PurchasesErrorCode.purchaseCancelledError;
      _logger.warn(
        'Restore failed: code=$code message=${e.message} details=${e.details}',
        tag: _logTag,
        error: e,
      );
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: isCancelled ? null : '$e',
        ),
      );
    } catch (e) {
      emit(state.copyWith(actionStatus: PaywallActionStatus.idle, error: '$e'));
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

  Future<void> _logEntitlementsSnapshot({required String context}) async {
    try {
      final info = await _revenueCatService.getCustomerInfo();
      final activeKeys = info.entitlements.active.keys.join(', ');
      final premium = info.entitlements.all[_premiumEntitlementId];
      _logger.info(
        'Entitlements snapshot [$context]: active=[$activeKeys] premiumExpires=${premium?.expirationDate} verification=${premium?.verification}',
        tag: _logTag,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log entitlements [$context]: $error',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ensureEntitlementActive() async {
    final active = await _revenueCatService.isEntitlementActive(
      _premiumEntitlementId,
    );
    if (!active) {
      throw Exception('Premium entitlement inactive after purchase');
    }
  }

  Future<void> _logStart(PaywallStarted event) async {
    try {
      final rcUserId = await Purchases.appUserID;
      _logger.debug(
        'Paywall start: homeId=$_homeId placement=$_placementId rcUserId=$rcUserId source=${event.source} triggers=${event.triggers}',
        tag: _logTag,
      );
    } catch (_) {}
  }

  Future<RevenueCatPackage?> _loadMonthlyPackage() async {
    try {
      final pkg = await _revenueCatService.fetchMonthlyPackage(
        placementId: _placementId,
      );
      if (pkg == null) {
        await _logMissingPackage();
      }
      return pkg;
    } catch (_) {
      await _logMissingPackage();
      return null;
    }
  }

  Future<void> _logMissingPackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentId = offerings.current?.identifier;
      final available =
          offerings.current?.availablePackages
              .map((p) => p.identifier)
              .join(', ') ??
          '';
      _logger.warn(
        'RevenueCat monthly package unavailable (currentOffering=$currentId availablePackages=[$available])',
        tag: _logTag,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to inspect RevenueCat offerings after missing monthly package',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<HomeMemberSummary>> _loadActiveMembers() async {
    try {
      return await _homeRepository.listActiveMembers(_homeId);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to load active members for paywall',
        tag: _logTag,
        error: error,
        stackTrace: stackTrace,
      );
      return const [];
    }
  }

  Future<void> _logImpressionSafe(String? source) async {
    try {
      await _logEvent(PaywallEventType.impression, source);
    } catch (_) {
      // Ignore telemetry errors to avoid blocking UI
    }
  }
}
