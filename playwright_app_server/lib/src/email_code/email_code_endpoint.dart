import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'email_code_login.dart';

/// Passwordless sign-in and sign-up with a one-time email code.
class EmailCodeEndpoint extends Endpoint {
  /// Emails a 6-digit sign-in code to [email].
  ///
  /// Behaves the same whether or not an account exists, so it does not reveal
  /// which emails are registered.
  Future<void> requestCode(Session session, String email) =>
      EmailCodeLogin.requestCode(session, email);

  /// Signs the player in with the [code] sent to [email], creating the
  /// account on first use.
  Future<EmailCodeSignIn> verifyCode(
    Session session,
    String email,
    String code,
  ) => EmailCodeLogin.verifyCode(session, email, code);
}
