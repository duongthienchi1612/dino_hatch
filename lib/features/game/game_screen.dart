import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/app/router.dart';
import 'package:dino_hatch/features/game/bubble_shooter/bubble_shooter.dart';

class GameScreen extends StatelessWidget {
  final String era;
  final int level;
  const GameScreen({super.key, required this.era, required this.level});

  static const double viewportWidth = 960;
  static const double viewportHeight = 540; // 16:9

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$era Lvl $level'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.go(Routes.dnaMap),
            child: const Text('Bản đồ', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: viewportWidth,
            height: viewportHeight,
            child: const BubbleShooterGame(),
          ),
        ),
      ),
    );
  }
}


