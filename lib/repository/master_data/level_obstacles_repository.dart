import 'package:dino_hatch/model/master_data/level_obstacles_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/master_data/level_obstacles_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class LevelObstaclesRepository extends BaseReadRepository<LevelObstaclesEntity> implements ILevelObstaclesRepository {
  LevelObstaclesRepository() : super(DatabaseName.masterData);
}
