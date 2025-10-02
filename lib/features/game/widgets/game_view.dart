import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dino_hatch/features/game/bubble_shooter/bubble_shooter.dart';
import 'package:dino_hatch/features/game/bloc/game_cubit.dart';

class GameView extends StatelessWidget {
  final LevelConfig levelConfig;
  final VoidCallback onWin;

  const GameView({
    super.key,
    required this.levelConfig,
    required this.onWin,
  });

  static const double viewportWidth = 960;
  static const double viewportHeight = 540; // 16:9

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (_) => GameCubit(
        rows: 12,
        cols: 9,
        palette: const <Color>[
          Color(0xFFE53935),
          Color(0xFF43A047),
          Color(0xFF1E88E5),
          Color(0xFFFB8C00),
          Color(0xFF8E24AA),
          Color(0xFFFDD835),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: viewportWidth,
            height: viewportHeight,
            child: BubbleShooterGame(
              config: levelConfig,
              onWin: onWin,
            ),
          ),
        ),
      ),
    );
  }
}
