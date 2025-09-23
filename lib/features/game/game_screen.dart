import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/app/router.dart';
import 'package:dino_hatch/features/game/bubble_shooter/bubble_shooter.dart';
import 'package:dino_hatch/features/game/bloc/game_cubit.dart';

class GameScreen extends StatelessWidget {
  final String era;
  final int level;
  const GameScreen({super.key, required this.era, required this.level});

  static const double viewportWidth = 960;
  static const double viewportHeight = 540; // 16:9

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (_) => GameCubit(rows: 12, cols: 9, palette: const <Color>[
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.yellow,
      ]),
      child: Scaffold(
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
      ),
    );
  }
}


