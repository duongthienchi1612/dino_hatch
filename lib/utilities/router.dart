import 'package:dino_hatch/features/dna_map/dna_map_screen.dart';
import 'package:dino_hatch/features/game/game_screen.dart';
import 'package:dino_hatch/features/home/home_screen.dart';
import 'package:dino_hatch/features/sanctuary/sanctuary_screen.dart';
import 'package:dino_hatch/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Central route paths.
class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String dnaMap = '/dna-map';
  static const String game = '/game/:era/:level';
  static const String sanctuary = '/sanctuary';
}

/// Global router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: <RouteBase>[
    GoRoute(path: Routes.splash, builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
    GoRoute(
      path: Routes.home,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(state: state, child: const HomeScreen()),
    ),
    GoRoute(
      path: Routes.dnaMap,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(state: state, child: const DnaMapScreen()),
    ),
    GoRoute(
      path: Routes.game,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String era = state.pathParameters['era']!;
        final int level = int.tryParse(state.pathParameters['level'] ?? '1') ?? 1;
        return buildPageWithDefaultTransition(
          state: state,
          child: GameScreen(eraName: era, levelId: level),
        );
      },
    ),
    // GoRoute(
    //   path: Routes.game,
    //   builder: (BuildContext context, GoRouterState state) {
    //     final String era = state.pathParameters['era']!;
    //     final int level = int.tryParse(state.pathParameters['level'] ?? '1') ?? 1;
    //     return GameScreen(eraName: era, levelId: level);
    //   },
    // ),
    GoRoute(
      path: Routes.sanctuary,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          buildPageWithDefaultTransition(state: state, child: const SanctuaryScreen()),
    ),
  ],
);

CustomTransitionPage<dynamic> buildPageWithDefaultTransition<T>({
  required GoRouterState state,
  required Widget child,
  Duration? transitionDuration,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
