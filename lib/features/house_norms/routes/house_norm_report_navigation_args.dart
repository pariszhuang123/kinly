import 'package:kinly/contracts/house_norms/models.dart';

class HouseNormReportNavigationArgs {
  const HouseNormReportNavigationArgs({
    required this.showConfetti,
    this.initialDocument,
    this.backRouteName,
  });

  final bool showConfetti;
  final HouseNormDocument? initialDocument;
  final String? backRouteName;
}
