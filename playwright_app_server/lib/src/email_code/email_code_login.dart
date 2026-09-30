import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';

/// Passwordless sign-in: the player enters an email, receives a 6-digit
/// one-time code and is signed in (or signed up) by entering it.
///
/// Accounts are the regular [EmailAccount]s of the email identity provider,
/// so players created before this flow existed keep their progress.
abstract final class EmailCodeLogin {
  static const codeLength = 6;
  static const codeLifetime = Duration(minutes: 10);
  static const maxFailedAttempts = 5;
  static const resendCooldown = Duration(seconds: 30);

  /// The sign-in method recorded on issued tokens.
  static const method = 'email';

  static final _emailPattern = RegExp(r'^\S+@\S+\.\S+$');
  static final _random = Random.secure();

  /// Generates the code to send. Only replace this in tests.
  static String Function() generateCode = () => List.generate(
    codeLength,
    (_) => _random.nextInt(10),
  ).join();

  /// Creates a new code for [rawEmail] and emails it.
  static Future<void> requestCode(Session session, String rawEmail) async {
    final email = _normalize(rawEmail);
    final now = DateTime.now().toUtc();
    final code = generateCode();

    await session.db.transaction((transaction) async {
      final existing = await EmailLoginCode.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
        transaction: transaction,
      );
      if (existing != null &&
          now.difference(existing.createdAt) < resendCooldown) {
        throw EmailCodeLoginException(
          reason: EmailCodeErrorReason.tooManyRequests,
        );
      }
      final row = EmailLoginCode(
        email: email,
        codeHash: _hash(email, code),
        createdAt: now,
        expiresAt: now.add(codeLifetime),
      );
      if (existing == null) {
        await EmailLoginCode.db.insertRow(
          session,
          row,
          transaction: transaction,
        );
      } else {
        await EmailLoginCode.db.updateRow(
          session,
          row.copyWith(id: existing.id),
          transaction: transaction,
        );
      }
    });

    await _send(session, email: email, code: code);
  }

  /// Checks [code] for [rawEmail]. On success the code is consumed, the
  /// account is created if needed, and a sign-in token is returned.
  static Future<EmailCodeSignIn> verifyCode(
    Session session,
    String rawEmail,
    String code,
  ) async {
    final email = _normalize(rawEmail);
    final now = DateTime.now().toUtc();

    // Failed attempts must be persisted even though we throw, so they are
    // recorded outside the sign-in transaction.
    final pending = await EmailLoginCode.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
    if (pending == null) {
      throw EmailCodeLoginException(reason: EmailCodeErrorReason.invalidCode);
    }
    if (now.isAfter(pending.expiresAt)) {
      await EmailLoginCode.db.deleteRow(session, pending);
      throw EmailCodeLoginException(reason: EmailCodeErrorReason.expired);
    }
    if (!_constantTimeEquals(pending.codeHash, _hash(email, code.trim()))) {
      final attempts = pending.failedAttempts + 1;
      if (attempts >= maxFailedAttempts) {
        await EmailLoginCode.db.deleteRow(session, pending);
        throw EmailCodeLoginException(
          reason: EmailCodeErrorReason.tooManyAttempts,
        );
      }
      await EmailLoginCode.db.updateRow(
        session,
        pending.copyWith(failedAttempts: attempts),
      );
      throw EmailCodeLoginException(reason: EmailCodeErrorReason.invalidCode);
    }

    return session.db.transaction((transaction) async {
      await EmailLoginCode.db.deleteRow(
        session,
        pending,
        transaction: transaction,
      );
      final auth = AuthServices.instance;
      final account = await auth.emailIdp.admin.findAccount(
        session,
        email: email,
        transaction: transaction,
      );

      final UuidValue authUserId;
      final isNewUser = account == null;
      if (account != null) {
        authUserId = account.authUserId;
      } else {
        final user = await auth.authUsers.create(
          session,
          transaction: transaction,
        );
        authUserId = user.id;
        await auth.emailIdp.admin.createEmailAuthentication(
          session,
          authUserId: authUserId,
          email: email,
          password: null,
          transaction: transaction,
        );
        await auth.userProfiles.createUserProfile(
          session,
          authUserId,
          UserProfileData(email: email),
          transaction: transaction,
        );
      }

      final user = await auth.authUsers.get(
        session,
        authUserId: authUserId,
        transaction: transaction,
      );
      final authSuccess = await auth.tokenManager.issueToken(
        session,
        authUserId: authUserId,
        method: method,
        scopes: user.scopes,
        transaction: transaction,
      );
      return EmailCodeSignIn(authSuccess: authSuccess, isNewUser: isNewUser);
    });
  }

  static String _normalize(String email) {
    final normalized = email.trim().toLowerCase();
    if (!_emailPattern.hasMatch(normalized)) {
      throw EmailCodeLoginException(reason: EmailCodeErrorReason.invalidEmail);
    }
    return normalized;
  }

  static String _hash(String email, String code) {
    final pepper =
        Serverpod.instance.getPassword('emailSecretHashPepper') ??
        'development-only-pepper';
    return Hmac(
      sha256,
      utf8.encode(pepper),
    ).convert(utf8.encode('$email:$code')).toString();
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  static Future<void> _send(
    Session session, {
    required String email,
    required String code,
  }) async {
    final runMode = Serverpod.instance.runMode;
    if (runMode == ServerpodRunMode.development ||
        runMode == ServerpodRunMode.test) {
      // Shown (and copied) by the `serverpod start` terminal UI.
      session.alert('Sign-in code for $email: <$code>');
      return;
    }
    try {
      await ServerpodCloudEmailClient().sendEmail(
        token: Serverpod.instance.getPassword('scloudAuthEmailKey')!,
        emailType: ServerpodCloudEmailType.signup,
        email: email,
        projectName: 'Playwright Quest',
        authCode: code,
      );
    } catch (e, stackTrace) {
      // Never reveal delivery problems to the caller; operators see the log.
      session.log(
        'Failed to send sign-in code to $email.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    }
  }
}
