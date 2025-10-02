import 'package:equatable/equatable.dart';

class LevelNode extends Equatable {
  final String eraName;
  final int levelId;
  const LevelNode({required this.eraName, required this.levelId});

  @override
  List<Object?> get props => <Object?>[eraName, levelId];
}

class LevelMapState extends Equatable {
  final bool loading;
  final List<LevelNode> nodes;
  final String? error;

  const LevelMapState({this.loading = false, this.nodes = const <LevelNode>[], this.error});

  LevelMapState copyWith({bool? loading, List<LevelNode>? nodes, String? error}) {
    return LevelMapState(
      loading: loading ?? this.loading,
      nodes: nodes ?? this.nodes,
      error: error,
    );
  }

  @override
  List<Object?> get props => <Object?>[loading, nodes, error];
}


