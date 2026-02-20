import 'package:intl/intl.dart';

import '../../../../generated/l10n.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';

String buildShareCreateSplitMismatchMessage({
  required S strings,
  required ShareCreateState state,
}) {
  final totalCents = state.form.amountCents;
  if (totalCents == null || totalCents <= 0) {
    return strings.shareCreateValidationCustomSum;
  }

  final summary = state.evaluateCustomSplit();
  final assignedCents = summary.entries.fold<int>(
    0,
    (sum, entry) => sum + entry.amountCents,
  );
  final differenceCents = totalCents - assignedCents;
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);

  return strings.shareCreateValidationCustomSumBreakdown(
    formatter.format(totalCents / 100.0),
    formatter.format(assignedCents / 100.0),
    _formatSignedCurrency(formatter, differenceCents),
  );
}

String _formatSignedCurrency(NumberFormat formatter, int amountCents) {
  if (amountCents == 0) {
    return formatter.format(0);
  }

  final absolute = formatter.format(amountCents.abs() / 100.0);
  if (amountCents > 0) {
    return '+$absolute';
  }
  return '-$absolute';
}
