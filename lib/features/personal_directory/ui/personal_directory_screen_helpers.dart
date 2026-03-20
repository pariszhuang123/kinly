part of 'personal_directory_screen.dart';

String personalDirectoryNoteTypeLabel(
  BuildContext context,
  PersonalDirectoryNoteType noteType,
) {
  final s = S.of(context);
  return switch (noteType) {
    PersonalDirectoryNoteType.emergencyContact =>
      s.personalDirectoryEmergencyContactTitle,
    PersonalDirectoryNoteType.allergy => s.personalDirectoryAllergyTitle,
    PersonalDirectoryNoteType.other => s.personalDirectoryOtherTitle,
  };
}

List<Widget> withVerticalSpacing(
  List<Widget> widgets, {
  required double spacing,
}) {
  if (widgets.isEmpty) return const <Widget>[];
  final children = <Widget>[];
  for (var index = 0; index < widgets.length; index++) {
    if (index > 0) {
      children.add(SizedBox(height: spacing));
    }
    children.add(widgets[index]);
  }
  return children;
}
