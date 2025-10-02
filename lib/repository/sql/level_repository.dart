import 'package:dino_hatch/model/entity/user_level_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/user_level_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class UserLevelRepository extends BaseRepository<UserLevelEntity> implements IUserLevelRepository {
  UserLevelRepository() : super(DatabaseName.dinoHatch);
  @override
  Future<List<UserLevelEntity>> getAllLevel() async {
    final listContact = await list(null, null, null, null, null);
    return listContact;
  }
}
