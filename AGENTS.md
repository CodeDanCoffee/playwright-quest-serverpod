# Flutter & Serverpod project

## The app: Playwright Quest ("From first test to pro")

A gamified, mobile-first quiz app that teaches Playwright (and test automation in general) to complete beginners and up. Theme: a theatre ("playwright") — difficulty tiers are *Acts*, lessons are *Scenes*, player ranks go Stagehand → Playwright.

- **Curriculum** (server, in code): `playwright_app_server/lib/src/quiz/content/curriculum.dart`. 4 tiers (Beginner, Intermediate, Advanced, Expert) × 3 lessons. Each lesson = concept card (body, code, pro tip) + questions (`mc`, `tf`, `blank` helpers in `curriculum_builder.dart`). Question/lesson ids must stay stable (progress is keyed by lesson id). The app shuffles options per attempt, so option order in content does not matter. `test/unit/game_rules_test.dart` validates the content.
- **Game rules**: `lib/src/quiz/game_rules.dart` — stars (60/80/100%), linear unlocking (≥1 star opens the next lesson), XP (10/correct + first-pass and first-perfect bonuses), daily UTC streaks.
- **Passwordless sign-in**: `lib/src/email_code/` — `EmailCodeEndpoint.requestCode(email)` / `verifyCode(email, code)` → `AuthSuccess`. 6-digit codes, stored only as an HMAC (keyed with `emailSecretHashPepper`) in `email_login_code`, 10-minute expiry, 5 wrong tries, 30 s resend cooldown. Accounts are regular email-IdP `EmailAccount`s (created with no password), so pre-existing users keep their progress. In development the code is logged via `session.alert`; otherwise it is sent through the Serverpod Cloud email service (`scloudAuthEmailKey`). `verifyCode` returns `EmailCodeSignIn { authSuccess, isNewUser }`; the app sets `GameController.pendingWelcome` (new vs returning) and calls `client.auth.updateSignedInUser`. `HomeScreen` (built to the home design spec: header, intro, a single "Start here" card as the only primary CTA, the acts as a list with lesson status/unlock reasons, rank card) says "Welcome back!" in its intro while `pendingWelcome` is `returning`; `openLesson` clears it. Spec colours that failed 4.5:1 contrast were darkened in `QuestColors` (see comments there). Shared spec styling lives in `lib/widgets/quest_ui.dart`.
- **Endpoint**: `QuizEndpoint` (`requireLogin`) — `getTiers`, `getLesson` (unlocked only), `getProgress`, `submitLesson(lessonId, answers)` graded server-side. Errors are `QuizException`.
- **Tables**: `lesson_progress` (best result per user+lesson) and `player_stats` (xp, streaks), both related to `AuthUser` with cascade delete.
- **Flutter**: `lib/theme.dart` (the `Stage` palette — a bright white theme with candy accents per tier, dark indigo code blocks — and typography: Baloo 2 bold headlines, Nunito body, JetBrains Mono code), `lib/game/game_controller.dart` (shared state via `GameScope`), screens in `lib/screens/` (sign-in gate — `sign_in_screen.dart`, built to the design spec with its own colours, email → code → done steps → home map → lesson intro → quiz → results), shared widgets in `lib/widgets/`.

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `playwright_app_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `playwright_app_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.
