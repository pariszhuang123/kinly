import 'package:kinly/contracts/house_norms/models.dart';

class HouseNormReportNavigationArgs {
  const HouseNormReportNavigationArgs({
    required this.showConfetti,
    this.initialDocument,
  });

  final bool showConfetti;
  final HouseNormDocument? initialDocument;
}
