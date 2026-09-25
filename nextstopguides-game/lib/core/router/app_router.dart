import 'package:flutter/material.dart';

import '../../features/game/presentation/game_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/results/presentation/results_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String game = '/game';
  static const String results = '/results';
}

/// Named-route navigation. Screens that need data receive a typed
/// arguments object (GameArgs, ResultsArgs). Unknown routes or missing
/// arguments (e.g. a browser refresh on /game) fall back to the home screen.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.game:
        if (args is GameArgs) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => GameScreen(args: args),
          );
        }
      case AppRoutes.results:
        if (args is ResultsArgs) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => ResultsScreen(args: args),
          );
        }
    }
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: AppRoutes.home),
      builder: (context) => const HomeShell(),
    );
  }
}
