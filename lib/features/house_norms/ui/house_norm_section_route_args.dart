import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';

class HouseNormSectionRouteArgs {
  HouseNormSectionRouteArgs({
    required this.sectionKey,
    required this.title,
    required this.text,
    required this.reportCubit,
  });

  final String sectionKey;
  final String title;
  final String text;
  final HouseNormReportCubit reportCubit;
}
