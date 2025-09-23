import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final int rows;
  final int cols;
  final List<Color> palette;
  final Random _rand = Random();

  GameCubit({required this.rows, required this.cols, required this.palette})
      : super(GameState.initial(rows: rows, cols: cols)) {
    _initGrid();
    _rollInitialBubbles();
  }

  void _initGrid() {
    final List<List<Color?>> g = List<List<Color?>>.generate(
        rows, (int r) => List<Color?>.generate(cols, (int c) => null));
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < cols; c++) {
        g[r][c] = palette[_rand.nextInt(palette.length)];
      }
    }
    emit(state.copyWith(grid: g));
  }

  void _rollInitialBubbles() {
    final Color a = palette[_rand.nextInt(palette.length)];
    final Color b = palette[_rand.nextInt(palette.length)];
    emit(state.copyWith(active: a, next: b));
  }

  void onShootConsumedShift() {
    // Called by engine immediately after firing: shift active -> next and roll new next
    final Color? nextColor = state.next;
    final Color newNext = palette[_rand.nextInt(palette.length)];
    emit(state.copyWith(active: nextColor, next: newNext));
  }

  void placeBubble(int row, int col, Color color) {
    final List<List<Color?>> g = state.grid.map((List<Color?> r) => List<Color?>.from(r)).toList();
    g[row][col] = color;
    emit(state.copyWith(grid: g));
  }

  void clearCells(List<List<int>> cells) {
    final List<List<Color?>> g = state.grid.map((List<Color?> r) => List<Color?>.from(r)).toList();
    for (final List<int> p in cells) {
      g[p[0]][p[1]] = null;
    }
    emit(state.copyWith(grid: g));
  }
}


