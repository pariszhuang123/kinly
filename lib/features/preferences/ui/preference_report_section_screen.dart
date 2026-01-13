import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/generated/l10n.dart';
import 'preference_report_section_route_args.dart';

class PreferenceReportSectionScreen extends StatefulWidget {
  const PreferenceReportSectionScreen({
    super.key,
    required this.args,
    PreferenceReportsRepository? repository,
  }) : _repository = repository;

  final PreferenceReportSectionRouteArgs args;
  final PreferenceReportsRepository? _repository;

  @override
  State<PreferenceReportSectionScreen> createState() =>
      _PreferenceReportSectionScreenState();
}

class _PreferenceReportSectionScreenState
    extends State<PreferenceReportSectionScreen> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  PreferenceReportsRepository get _repository =>
      widget._repository ?? sl<PreferenceReportsRepository>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.args.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final resolution = await _repository.getTemplateResolution();
      await _repository.editSectionText(
        locale: resolution.resolvedLocale,
        sectionKey: widget.args.sectionKey,
        text: _controller.text.trim(),
      );
      if (mounted) {
        context.pop(true);
      }
    } catch (error) {
      if (!mounted) return;
      KinlySnackBar.showError(context, S.of(context).preferenceReportEditError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final preferenceColors = context.preferenceSection;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(widget.args.title),
        leading: _DirectionalBackButton(
          label: s.preferenceOnboardingBack,
          colors: preferenceColors,
          onTap: () => context.pop(false),
        ),
        backgroundColor: surface,
        foregroundColor: onSurface,
      ),
      backgroundColor: surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing?.lg ?? 16,
            spacing?.lg ?? 16,
            spacing?.lg ?? 16,
            spacing?.xl ?? 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.preferenceReportEditSectionPrompt),
              SizedBox(height: spacing?.m ?? 12),
              KinlyTextField(
                controller: _controller,
                maxLines: 8,
                minLines: 4,
                hintText: s.preferenceReportEditSectionHint,
              ),
              SizedBox(height: spacing?.lg ?? 16),
              KinlyFilledButton.text(
                fullWidth: true,
                label: s.preferenceReportEditSectionDone,
                backgroundColor: preferenceColors.accent,
                foregroundColor: preferenceColors.onAccent(),
                onPressed: _isSaving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectionalBackButton extends StatelessWidget {
  const _DirectionalBackButton({
    required this.onTap,
    required this.label,
    required this.colors,
  });

  final VoidCallback onTap;
  final String label;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: label,
      child: KinlyTapTarget(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: Transform.scale(
              scaleX: isRtl ? 1.0 : -1.0,
              scaleY: 1.0,
              child: Icon(KinlyIcons.chevronRightRounded, color: colors.icon),
            ),
          ),
        ),
      ),
    );
  }
}
