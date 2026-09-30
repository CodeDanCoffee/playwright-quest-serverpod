import 'package:playwright_app_server/src/email_code/email_code_login.dart';
import 'package:playwright_app_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the EmailCode endpoint', (sessionBuilder, endpoints) {
    const email = 'ada@example.com';
    var nextCode = '123456';

    setUpAll(() {
      AuthServices.set(
        tokenManagerBuilders: [JwtConfigFromPasswords()],
        identityProviderBuilders: [
          ServerpodCloudEmailIdpConfig(appDisplayName: 'test'),
        ],
      );
      EmailCodeLogin.generateCode = () => nextCode;
    });

    setUp(() => nextCode = '123456');

    Future<EmailLoginCode?> storedCode() => EmailLoginCode.db.findFirstRow(
      sessionBuilder.build(),
      where: (t) => t.email.equals(email),
    );

    test('when requesting a code then only a hash is stored', () async {
      await endpoints.emailCode.requestCode(
        sessionBuilder,
        ' Ada@Example.com ',
      );
      final row = await storedCode();
      expect(row, isNotNull);
      expect(row!.codeHash, isNot(contains('123456')));
    });

    test('when requesting twice quickly then the second is refused', () async {
      await endpoints.emailCode.requestCode(sessionBuilder, email);
      await expectLater(
        endpoints.emailCode.requestCode(sessionBuilder, email),
        throwsA(
          isA<EmailCodeLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailCodeErrorReason.tooManyRequests,
          ),
        ),
      );
    });

    test('when requesting with an invalid email then it throws', () async {
      await expectLater(
        endpoints.emailCode.requestCode(sessionBuilder, 'not-an-email'),
        throwsA(
          isA<EmailCodeLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailCodeErrorReason.invalidEmail,
          ),
        ),
      );
    });

    test('when verifying the right code then a new account signs in', () async {
      await endpoints.emailCode.requestCode(sessionBuilder, email);
      final result = await endpoints.emailCode.verifyCode(
        sessionBuilder,
        email,
        '123456',
      );
      final auth = result.authSuccess;
      expect(auth.token, isNotEmpty);
      expect(result.isNewUser, isTrue);

      final account = await AuthServices.instance.emailIdp.admin.findAccount(
        sessionBuilder.build(),
        email: email,
      );
      expect(account?.authUserId, auth.authUserId);
      expect(await storedCode(), isNull, reason: 'code is single-use');
    });

    test('when an account exists then the same user signs in', () async {
      final session = sessionBuilder.build();
      final user = await AuthServices.instance.authUsers.create(session);
      await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: user.id,
        email: email,
        password: 'Existing-Passw0rd!',
      );

      await endpoints.emailCode.requestCode(sessionBuilder, email);
      final result = await endpoints.emailCode.verifyCode(
        sessionBuilder,
        email,
        '123456',
      );
      expect(result.authSuccess.authUserId, user.id);
      expect(result.isNewUser, isFalse);
    });

    test('when verifying a wrong code then attempts are counted', () async {
      await endpoints.emailCode.requestCode(sessionBuilder, email);
      await expectLater(
        endpoints.emailCode.verifyCode(sessionBuilder, email, '000000'),
        throwsA(
          isA<EmailCodeLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailCodeErrorReason.invalidCode,
          ),
        ),
      );
      expect((await storedCode())!.failedAttempts, 1);
    });

    test('when guessing too often then the code is revoked', () async {
      await endpoints.emailCode.requestCode(sessionBuilder, email);
      for (var i = 1; i < EmailCodeLogin.maxFailedAttempts; i++) {
        await expectLater(
          endpoints.emailCode.verifyCode(sessionBuilder, email, '000000'),
          throwsA(isA<EmailCodeLoginException>()),
        );
      }
      await expectLater(
        endpoints.emailCode.verifyCode(sessionBuilder, email, '000000'),
        throwsA(
          isA<EmailCodeLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailCodeErrorReason.tooManyAttempts,
          ),
        ),
      );
      await expectLater(
        endpoints.emailCode.verifyCode(sessionBuilder, email, '123456'),
        throwsA(isA<EmailCodeLoginException>()),
        reason: 'the right code no longer works either',
      );
    });

    test('when the code has expired then it is rejected', () async {
      await endpoints.emailCode.requestCode(sessionBuilder, email);
      final row = (await storedCode())!;
      await EmailLoginCode.db.updateRow(
        sessionBuilder.build(),
        row.copyWith(
          expiresAt: DateTime.now().toUtc().subtract(
            const Duration(seconds: 1),
          ),
        ),
      );
      await expectLater(
        endpoints.emailCode.verifyCode(sessionBuilder, email, '123456'),
        throwsA(
          isA<EmailCodeLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailCodeErrorReason.expired,
          ),
        ),
      );
    });
  });
}
