import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';

class InfoHubWebViewScreen extends StatefulWidget {
  const InfoHubWebViewScreen({super.key});

  static const infoHubUrl =
      'https://www.notion.so/2a9b40335c2d80d6bf98d25abb40ed18'
      '?v=2a9b40335c2d81c3b23e000c8f2568d5&source=copy_link';

  @override
  State<InfoHubWebViewScreen> createState() => _InfoHubWebViewScreenState();
}

class _InfoHubWebViewScreenState extends State<InfoHubWebViewScreen> {
  double _progress = 0;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (value) {
                setState(() {
                  _progress = value / 100;
                });
              },
              onWebResourceError: (error) {
                if (!mounted) return;
                KinlySnackBar.showError(
                  context,
                  S.of(context).profileInfoHubLoadError,
                );
              },
            ),
          )
          ..loadRequest(Uri.parse(InfoHubWebViewScreen.infoHubUrl));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.profileInfoHubTitle),
        actions: [
          if (_progress < 1)
            Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: const KinlyLoader(size: 20),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
