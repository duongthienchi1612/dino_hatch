import 'package:dino_hatch/model/entity/level_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

abstract class ILevelRepository extends IBaseRepository<LevelEntity> {
  Future<List<LevelEntity>> getAllLevel();
}
