BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lesson_progress" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "lessonId" text NOT NULL,
    "bestCorrect" bigint NOT NULL,
    "total" bigint NOT NULL,
    "stars" bigint NOT NULL,
    "attempts" bigint NOT NULL,
    "lastPlayedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "lesson_progress_user_lesson_idx" ON "lesson_progress" USING btree ("authUserId", "lessonId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_stats" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "xp" bigint NOT NULL DEFAULT 0,
    "currentStreak" bigint NOT NULL DEFAULT 0,
    "longestStreak" bigint NOT NULL DEFAULT 0,
    "lastPlayedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "player_stats_user_idx" ON "player_stats" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "lesson_progress"
    ADD CONSTRAINT "lesson_progress_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player_stats"
    ADD CONSTRAINT "player_stats_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR playwright_app
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('playwright_app', '20260930042126963-quiz-progress', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260930042126963-quiz-progress', "timestamp" = now();

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
