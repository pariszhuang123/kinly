import 'package:kinly/contracts/auth/models/user_context.dart';

/// Port for fetching caller-scoped user context used for personal profile access.
abstract class UserContextRepository {
  Future<UserContext> fetch();
}
