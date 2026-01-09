import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';

part 'preference_report_state.dart';

class PreferenceReportCubit extends Cubit<PreferenceReportState> {
  PreferenceReportCubit({
    required PreferenceReportsRepository repository,
    required String homeId,
    required String subjectUserId,
    String templateKey = 'personal_preferences_v1',
  }) : _repository = repository,
       _homeId = homeId,
       _subjectUserId = subjectUserId,
       _templateKey = templateKey,
       super(const PreferenceReportState.loading());

  final PreferenceReportsRepository _repository;
  final String _homeId;
  final String _subjectUserId;
  final String _templateKey;

  Future<void> load() async {
    emit(const PreferenceReportState.loading());
    try {
      final resolution = await _repository.getTemplateResolution(
        templateKey: _templateKey,
      );
      final resolvedLocale = resolution.resolvedLocale;
      final report = await _repository.getReportForHome(
        homeId: _homeId,
        subjectUserId: _subjectUserId,
        templateKey: _templateKey,
        locale: resolvedLocale,
      );
      if (report == null) {
        emit(const PreferenceReportState.empty());
        return;
      }
      emit(PreferenceReportState.ready(report));
    } catch (error) {
      emit(PreferenceReportState.failure(error.toString()));
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<bool> editSectionText({
    required String sectionKey,
    required String text,
  }) async {
    try {
      final resolution = await _repository.getTemplateResolution(
        templateKey: _templateKey,
      );
      await _repository.editSectionText(
        templateKey: _templateKey,
        locale: resolution.resolvedLocale,
        sectionKey: sectionKey,
        text: text,
      );
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}
