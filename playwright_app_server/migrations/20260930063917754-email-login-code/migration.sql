BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "email_login_code" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "codeHash" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "failedAttempts" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE UNIQUE INDEX "email_login_code_email_idx" ON "email_login_code" USING btree ("email");


--
-- MIGRATION VERSION FOR playwright_app
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('playwright_app', '20260930063917754-email-login-code', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260930063917754-email-login-code', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
