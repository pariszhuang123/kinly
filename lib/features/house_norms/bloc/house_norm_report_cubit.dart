import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';

part 'house_norm_report_state.dart';

class HouseNormReportCubit extends Cubit<HouseNormReportState> {
  HouseNormReportCubit({
    required HouseNormsRepository repository,
    required String homeId,
    required String locale,
    required bool isOwner,
    HouseNormDocument? initialDocument,
  }) : _repository = repository,
       _homeId = homeId,
       _locale = locale,
       _isOwner = isOwner,
       super(
         initialDocument != null
             ? HouseNormReportState.ready(initialDocument, isOwner: isOwner)
             : HouseNormReportState.loading(isOwner: isOwner),
       );

  final HouseNormsRepository _repository;
  final String _homeId;
  final String _locale;
  final bool _isOwner;

  Future<void> load() async {
    emit(HouseNormReportState.loading(isOwner: _isOwner));
    try {
      final document = await _repository.getForHome(homeId: _homeId, locale: _locale);
      if (document == null) {
        emit(HouseNormReportState.empty(isOwner: _isOwner));
        return;
      }
      emit(HouseNormReportState.ready(document, isOwner: _isOwner));
    } catch (error) {
      emit(HouseNormReportState.failure(error.toString(), isOwner: _isOwner));
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<bool> editSectionText({
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {
    if (!_isOwner) return false;
    try {
      final updated = await _repository.editSectionText(
        homeId: _homeId,
        locale: _locale,
        sectionKey: sectionKey,
        text: text,
        changeSummary: changeSummary,
      );
      emit(HouseNormReportState.ready(updated, isOwner: _isOwner));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> publish() async {
    if (!_isOwner) return false;
    final current = state.document;
    if (current == null) return false;
    emit(HouseNormReportState.busy(current, isOwner: _isOwner));
    try {
      final updated = await _repository.publishForHome(
        homeId: _homeId,
        locale: _locale,
      );
      emit(HouseNormReportState.ready(updated, isOwner: _isOwner));
      return true;
    } catch (error) {
      emit(HouseNormReportState.failure(error.toString(), isOwner: _isOwner));
      return false;
    }
  }
}
