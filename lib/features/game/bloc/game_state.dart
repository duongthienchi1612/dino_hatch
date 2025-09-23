import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GameState extends Equatable {
  final List<List<Color?>> grid; // null = empty; color keyed for simplicity
  final Color? active;
  final Color? next;
  final int score;
  final bool isPaused;
  final bool isWin;
  final bool isLose;

  const GameState({
    required this.grid,
    required this.active,
    required this.next,
    this.score = 0,
    this.isPaused = false,
    this.isWin = false,
    this.isLose = false,
  });

  factory GameState.initial({required int rows, required int cols}) {
    return GameState(
      grid: List<List<Color?>>.generate(
          rows, (int r) => List<Color?>.generate(cols, (int c) => null)),
      active: null,
      next: null,
    );
  }

  GameState copyWith({
    List<List<Color?>>? grid,
    Color? active,
    Color? next,
    int? score,
    bool? isPaused,
    bool? isWin,
    bool? isLose,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      active: active ?? this.active,
      next: next ?? this.next,
      score: score ?? this.score,
      isPaused: isPaused ?? this.isPaused,
      isWin: isWin ?? this.isWin,
      isLose: isLose ?? this.isLose,
    );
  }

  @override
  List<Object?> get props => <Object?>[grid, active, next, score, isPaused, isWin, isLose];
}


