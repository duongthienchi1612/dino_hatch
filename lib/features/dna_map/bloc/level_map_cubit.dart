import 'package:bloc/bloc.dart';
import 'package:dino_hatch/business/master_data_business.dart';
import 'package:dino_hatch/model/master_data/era_entity.dart';
import 'package:dino_hatch/model/master_data/level_entity.dart';
import 'package:flutter/material.dart';
import 'level_map_state.dart';

class LevelMapCubit extends Cubit<LevelMapState> {
  final MasterDataBusiness business;
  LevelMapCubit(this.business) : super(const LevelMapState(loading: true));

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await business.init();
      final List<EraEntity> eras = business.era ?? <EraEntity>[];
      final List<LevelEntity> levels = business.level ?? <LevelEntity>[];
      final List<LevelNode> nodes = <LevelNode>[];
      for (final EraEntity e in eras) {
        final int eraId = e.id ?? -1;
        final String eraName = e.nameVi ?? 'Era';
        final List<LevelEntity> filtered =
            levels.where((lv) => (lv.eraId ?? -2) == eraId).toList()
              ..sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        for (final LevelEntity lv in filtered) {
          nodes.add(LevelNode(eraName: eraName, levelId: lv.id ?? 0));
        }
      }
      emit(state.copyWith(loading: false, nodes: nodes));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}


