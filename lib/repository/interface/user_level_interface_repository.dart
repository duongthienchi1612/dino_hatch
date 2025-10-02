import 'package:dino_hatch/model/entity/user_level_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

abstract class IUserLevelRepository extends IBaseRepository<UserLevelEntity> {
  Future<List<UserLevelEntity>> getAllLevel();
}
