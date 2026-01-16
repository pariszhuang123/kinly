import 'package:kinly/contracts/auth/models/user_context.dart';

extension UserContextX on UserContext {
  bool get hasPersonalArtifact => hasPreferenceReport || hasPersonalMentions;
}
