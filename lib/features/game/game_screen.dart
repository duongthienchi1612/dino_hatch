import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/utilities/router.dart';
import 'package:dino_hatch/features/game/bloc/game_screen_cubit.dart';
import 'package:dino_hatch/features/game/widgets/game_view.dart';
import 'package:dino_hatch/features/game/widgets/win_dialog.dart';

class GameScreen extends StatelessWidget {
  final String eraName;
  final int levelId;
  
  const GameScreen({
    super.key,
    required this.eraName,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameScreenCubit()..loadLevelConfig(levelId),
      child: GameScreenView(
        eraName: eraName,
        levelId: levelId,
      ),
    );
  }
}

class GameScreenView extends StatelessWidget {
  final String eraName;
  final int levelId;

  const GameScreenView({
    super.key,
    required this.eraName,
    required this.levelId,
  });

  void _onWin(BuildContext context) {
    WinDialog.show(context, eraName, levelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$eraName Lvl $levelId'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.go(Routes.dnaMap),
            child: const Text(
              'Bản đồ',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GameScreenCubit, GameScreenState>(
        builder: (context, state) {
          switch (state.status) {
            case GameScreenStatus.initial:
            case GameScreenStatus.loading:
              return const Center(child: CircularProgressIndicator());
              
            case GameScreenStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<GameScreenCubit>().loadLevelConfig(levelId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
              
            case GameScreenStatus.success:
              return GameView(
                levelConfig: state.levelConfig!,
                onWin: () => _onWin(context),
              );
          }
        },
      ),
    );
  }
}