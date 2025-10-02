import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/utilities/router.dart';
import 'package:dino_hatch/features/game/bubble_shooter/bubble_shooter.dart';
import 'package:dino_hatch/features/game/bloc/game_cubit.dart';
import 'package:dino_hatch/business/master_data_business.dart';
import 'package:dino_hatch/dependencies.dart';
import 'package:dino_hatch/model/master_data/level_entity.dart';
import 'package:dino_hatch/model/master_data/level_obstacles_entity.dart';

class GameScreen extends StatefulWidget {
  final String eraName;
  final int levelId;
  const GameScreen({super.key, required this.eraName, required this.levelId});

  static const double viewportWidth = 960;
  static const double viewportHeight = 540; // 16:9

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _masterDataBusiness = injector.get<MasterDataBusiness>();
  LevelConfig? _levelConfig;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLevelConfig();
  }

  Future<void> _loadLevelConfig() async {
    try {
      await _masterDataBusiness.init();
      
      // Find the level by ID
      final LevelEntity? levelEntity = _masterDataBusiness.level
          ?.firstWhere((l) => l.id == widget.levelId, orElse: () => throw Exception('Level not found'));
      
      if (levelEntity == null) {
        throw Exception('Level ${widget.levelId} not found');
      }

      // Parse win mode
      LevelWinMode winMode = LevelWinMode.clearAll;
      if (levelEntity.winMode == 'drop_obstacles') {
        winMode = LevelWinMode.dropObstacles;
      }

      // Get obstacles for this level
      final List<LevelObstaclesEntity> levelObstacles = _masterDataBusiness.levelObstacles
          ?.where((o) => o.levelId == widget.levelId).toList() ?? [];

      List<Point<int>>? obstacles;
      if (levelObstacles.isNotEmpty) {
        obstacles = levelObstacles
            .map((o) => Point<int>(o.row ?? 0, o.column ?? 0))
            .toList();
      }

      setState(() {
        _levelConfig = LevelConfig(
          winMode: winMode,
          obstacleCount: levelEntity.obstacleCount ?? 0,
          obstacles: obstacles,
        );
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onWin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chúc mừng!'),
        content: Text('Bạn đã hoàn thành ${widget.eraName} Level ${widget.levelId}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(Routes.dnaMap);
            },
            child: const Text('Về bản đồ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eraName} Lvl ${widget.levelId}'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.go(Routes.dnaMap),
            child: const Text('Bản đồ', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : BlocProvider<GameCubit>(
                  create: (_) => GameCubit(rows: 12, cols: 9, palette: const <Color>[
                    Color(0xFFE53935),
                    Color(0xFF43A047),
                    Color(0xFF1E88E5),
                    Color(0xFFFB8C00),
                    Color(0xFF8E24AA),
                    Color(0xFFFDD835),
                  ]),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: GameScreen.viewportWidth,
                        height: GameScreen.viewportHeight,
                        child: BubbleShooterGame(
                          config: _levelConfig!,
                          onWin: _onWin,
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}


