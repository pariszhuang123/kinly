import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';
import 'package:kinly/features/house_norms/ui/house_norm_section_route_args.dart';
import 'package:kinly/generated/l10n.dart';

class HouseNormSectionScreen extends StatefulWidget {
  const HouseNormSectionScreen({super.key, required this.args});

  final HouseNormSectionRouteArgs args;

  @override
  State<HouseNormSectionScreen> createState() => _HouseNormSectionScreenState();
}

class _HouseNormSectionScreenState extends State<HouseNormSectionScreen> {
  late final TextEditingController _controller;
  bool _isSaving = false;

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
    final text = _controller.text.trim();
    if (text.isEmpty) {
      KinlySnackBar.showError(context, S.of(context).houseNormSectionEmptyError);
      return;
    }

    setState(() => _isSaving = true);
    final success = await context.read<HouseNormReportCubit>().editSectionText(
      sectionKey: widget.args.sectionKey,
      text: text,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (!success) {
      KinlySnackBar.showError(context, S.of(context).houseNormSectionSaveFailed);
      return;
    }
    KinlySnackBar.showSuccess(context, S.of(context).houseNormSectionSaveSuccess);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final palette = context.houseNormSection;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(widget.args.title),
        backgroundColor: palette.background,
        foregroundColor: palette.icon,
      ),
      backgroundColor: theme.colorScheme.surface,
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
              KinlyTextField(
                controller: _controller,
                labelText: s.houseNormSectionEditLabel,
                minLines: 5,
                maxLines: 10,
              ),
              SizedBox(height: spacing?.lg ?? 16),
              KinlyFilledButton.text(
                fullWidth: true,
                label: s.houseNormSectionSaveCta,
                backgroundColor: palette.accent,
                onPressed: _isSaving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
