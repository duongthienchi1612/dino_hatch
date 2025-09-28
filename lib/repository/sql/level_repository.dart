import 'package:dino_hatch/model/entity/level_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/level_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class LevelRepository extends BaseRepository<LevelEntity> implements ILevelRepository {
  LevelRepository() : super(DatabaseName.dinoHatch);
  @override
  Future<List<LevelEntity>> getAllLevel() async {
    final listContact = await list(null, null, null, null, null);
    return listContact;
  }
}
