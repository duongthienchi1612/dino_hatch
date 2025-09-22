import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dino_hatch/features/splash/splash_screen.dart';
import 'package:dino_hatch/features/home/home_screen.dart';
import 'package:dino_hatch/features/dna_map/dna_map_screen.dart';
import 'package:dino_hatch/features/game/game_screen.dart';

/// Central route paths.
class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String dnaMap = '/dna-map';
  static const String game = '/game/:era/:level';
}

/// Global router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: Routes.dnaMap,
      builder: (BuildContext context, GoRouterState state) =>
          const DnaMapScreen(),
    ),
    GoRoute(
      path: Routes.game,
      builder: (BuildContext context, GoRouterState state) {
        final String era = state.pathParameters['era']!;
        final int level =
            int.tryParse(state.pathParameters['level'] ?? '1') ?? 1;
        return GameScreen(era: era, level: level);
      },
    ),
  ],
);


