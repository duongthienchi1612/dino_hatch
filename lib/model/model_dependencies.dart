import 'package:dino_hatch/model/entity/dinosaur_entity.dart';
import 'package:dino_hatch/model/entity/egg_entity.dart';
import 'package:dino_hatch/model/entity/level_entity.dart';
import 'package:dino_hatch/model/entity/sanctuary_entity.dart';
import 'package:dino_hatch/model/master_data/era_entity.dart';
import 'package:dino_hatch/model/master_data/species_entity.dart';
import 'package:get_it/get_it.dart';


class ModelDependencies {
  static void init(GetIt injector) {
    // master data
    injector.registerFactory<SpeciesEntity>(() => SpeciesEntity());
    injector.registerFactory<EraEntity>(() => EraEntity());

    // user data 
    injector.registerFactory<LevelEntity>(() => LevelEntity());
    injector.registerFactory<EggEntity>(() => EggEntity());
    injector.registerFactory<DinosaurEntity>(() => DinosaurEntity());
    injector.registerFactory<SanctuaryEntity>(() => SanctuaryEntity());
  }
}
