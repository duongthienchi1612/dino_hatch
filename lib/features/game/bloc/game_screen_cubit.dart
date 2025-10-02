import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dino_hatch/business/master_data_business.dart';
import 'package:dino_hatch/dependencies.dart';
import 'package:dino_hatch/model/master_data/level_entity.dart';
import 'package:dino_hatch/model/master_data/level_obstacles_entity.dart';
import 'package:dino_hatch/features/game/bubble_shooter/bubble_shooter.dart';

// State
enum GameScreenStatus { initial, loading, success, failure }

class GameScreenState extends Equatable {
  final GameScreenStatus status;
  final LevelConfig? levelConfig;
  final String? error;

  const GameScreenState({
    this.status = GameScreenStatus.initial,
    this.levelConfig,
    this.error,
  });

  GameScreenState copyWith({
    GameScreenStatus? status,
    LevelConfig? levelConfig,
    String? error,
  }) {
    return GameScreenState(
      status: status ?? this.status,
      levelConfig: levelConfig ?? this.levelConfig,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, levelConfig, error];
}

// Cubit
class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit() : super(const GameScreenState());

  final _masterDataBusiness = injector.get<MasterDataBusiness>();

  Future<void> loadLevelConfig(int levelId) async {
    emit(state.copyWith(status: GameScreenStatus.loading));
    
    try {
      await _masterDataBusiness.init();
      
      // Find the level by ID
      final LevelEntity? levelEntity = _masterDataBusiness.level
          ?.where((l) => l.id == levelId)
          .firstOrNull;
      
      if (levelEntity == null) {
        throw Exception('Level $levelId not found');
      }

      // Parse win mode
      LevelWinMode winMode = LevelWinMode.clearAll;
      if (levelEntity.winMode == 'drop_obstacles') {
        winMode = LevelWinMode.dropObstacles;
      }

      // Get obstacles for this level
      final List<LevelObstaclesEntity> levelObstacles = _masterDataBusiness.levelObstacles
          ?.where((o) => o.levelId == levelId).toList() ?? [];

      List<Point<int>>? obstacles;
      if (levelObstacles.isNotEmpty) {
        obstacles = levelObstacles
            .map((o) => Point<int>(o.row ?? 0, o.column ?? 0))
            .toList();
      }

      final levelConfig = LevelConfig(
        winMode: winMode,
        obstacleCount: levelEntity.obstacleCount ?? 0,
        obstacles: obstacles,
      );

      emit(state.copyWith(
        status: GameScreenStatus.success,
        levelConfig: levelConfig,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GameScreenStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
