import 'package:flutter/material.dart';

import 'client.dart';
import 'game/game_controller.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const PlaywrightQuestApp());
}

class PlaywrightQuestApp extends StatefulWidget {
  const PlaywrightQuestApp({super.key});

  @override
  State<PlaywrightQuestApp> createState() => _PlaywrightQuestAppState();
}

class _PlaywrightQuestAppState extends State<PlaywrightQuestApp> {
  final _game = GameController();

  @override
  void dispose() {
    _game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameScope(
      controller: _game,
      child: MaterialApp(
        title: 'Playwright Quest',
        debugShowCheckedModeBanner: false,
        theme: buildStageTheme(),
        home: const SignInScreen(child: HomeScreen()),
      ),
    );
  }
}
