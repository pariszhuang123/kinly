import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

class HouseDirectoryWifiScreen extends StatefulWidget {
  const HouseDirectoryWifiScreen({
    super.key,
    required this.homeId,
    this.wifi,
  });

  final String homeId;
  final HouseDirectoryWifi? wifi;

  @override
  State<HouseDirectoryWifiScreen> createState() =>
      _HouseDirectoryWifiScreenState();
}

class _HouseDirectoryWifiScreenState extends State<HouseDirectoryWifiScreen> {
  late final TextEditingController _ssidController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _ssidController = TextEditingController(text: widget.wifi?.ssid ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(
          widget.wifi == null
              ? s.houseDirectoryAddWifi
              : s.houseDirectoryEditWifi,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KinlyTextField(
                        controller: _ssidController,
                        labelText: s.houseDirectorySsidLabel,
                      ),
                      SizedBox(height: spacing.md),
                      KinlyTextField(
                        controller: _passwordController,
                        labelText: s.houseDirectoryPasswordLabel,
                        hintText: s.houseDirectoryPasswordHelper,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing.lg),
              KinlyFilledButton.text(
                onPressed: _save,
                label: s.houseDirectorySave,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(
      UpsertHouseDirectoryWifiInput(
        homeId: widget.homeId,
        ssid: _ssidController.text.trim(),
        password:
            _passwordController.text.trim().isEmpty
                ? null
                : _passwordController.text,
      ),
    );
  }
}
