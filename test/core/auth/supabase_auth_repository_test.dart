import 'package:mocktail/mocktail.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';

import 'package:kinly/core/auth/supabase_auth_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockGoogleSignIn extends Mock implements GoogleSignIn {}

class _MockAppleSignInProvider extends Mock implements AppleSignInProvider {}

void main() {
  late _MockSupabaseClient supabaseClient;
  late _MockGoTrueClient goTrueClient;
  late _MockAppleSignInProvider appleProvider;

  setUp(() {
    supabaseClient = _MockSupabaseClient();
    goTrueClient = _MockGoTrueClient();
    appleProvider = _MockAppleSignInProvider();

    when(() => supabaseClient.auth).thenReturn(goTrueClient);
    when(
      () => goTrueClient.onAuthStateChange,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => goTrueClient.currentSession).thenReturn(null);
    when(() => appleProvider.isAvailable()).thenAnswer((_) async => true);
  });

  SupabaseAuthRepository buildRepo() => SupabaseAuthRepository(
    client: supabaseClient,
    googleSignIn: _MockGoogleSignIn(),
    appleSignInProvider: appleProvider,
    platformCheck: () => true,
    logger: const DebugLogger(),
  );

  test(
    'Apple sign-in cancel returns silently and does not hit Supabase',
    () async {
      when(
        () => appleProvider.getAppleIDCredential(
          scopes: any(named: 'scopes'),
          nonce: any(named: 'nonce'),
        ),
      ).thenThrow(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.canceled,
          message: 'User canceled',
        ),
      );

      final repo = buildRepo();

      await expectLater(repo.signInWithApple(), completes);
      verifyNever(
        () => goTrueClient.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: any(named: 'idToken'),
          nonce: any(named: 'nonce'),
          accessToken: any(named: 'accessToken'),
        ),
      );
    },
  );

  test(
    'Apple sign-in surfaces non-cancel errors and does not hit Supabase',
    () async {
      when(
        () => appleProvider.getAppleIDCredential(
          scopes: any(named: 'scopes'),
          nonce: any(named: 'nonce'),
        ),
      ).thenThrow(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.failed,
          message: 'Something went wrong',
        ),
      );

      final repo = buildRepo();

      await expectLater(
        repo.signInWithApple(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('failed'),
          ),
        ),
      );
      verifyNever(
        () => goTrueClient.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: any(named: 'idToken'),
          nonce: any(named: 'nonce'),
          accessToken: any(named: 'accessToken'),
        ),
      );
    },
  );
}
