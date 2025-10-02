import 'package:dino_hatch/model/master_data/level_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/master_data/level_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class LevelRepository extends BaseReadRepository<LevelEntity> implements ILevelRepository {
  LevelRepository() : super(DatabaseName.masterData);

  @override
  Future<List<LevelEntity>> getLevelsByEraId(int eraId) {
    return list(null, null, null, null, null);
  }
}
