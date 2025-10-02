import 'package:dino_hatch/model/master_data/level_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

  abstract class ILevelRepository extends IBaseReadRepository<LevelEntity> {
  Future<List<LevelEntity>> getLevelsByEraId(int eraId);
}
