import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/paywall/paywall_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/paywall_repository.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  PaywallBloc({
    required PaywallRepository paywallRepository,
    required RevenueCatService revenueCatService,
    required AuthRepository authRepository,
    required String homeId,
  })  : _paywallRepository = paywallRepository,
        _revenueCatService = revenueCatService,
        _authRepository = authRepository,
        _homeId = homeId,
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

  Future<void> _onStarted(
    PaywallStarted event,
    Emitter<PaywallState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PaywallLoadStatus.loading,
        error: null,
      ),
    );
    try {
      RevenueCatPackage? pkg;
      try {
        pkg = await _revenueCatService.fetchMonthlyPackage();
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
      state.copyWith(
        actionStatus: PaywallActionStatus.purchasing,
        error: null,
      ),
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
      final pkg = state.package ?? await _revenueCatService.fetchMonthlyPackage();
      if (pkg == null) {
        throw Exception('Missing monthly package');
      }
      await _revenueCatService.purchaseMonthly(pkg);
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: '$e',
        ),
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
      state.copyWith(
        actionStatus: PaywallActionStatus.restoring,
        error: null,
      ),
    );
    try {
      await _revenueCatService.restorePurchases();
      emit(state.copyWith(actionStatus: PaywallActionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: PaywallActionStatus.idle,
          error: '$e',
        ),
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
}
