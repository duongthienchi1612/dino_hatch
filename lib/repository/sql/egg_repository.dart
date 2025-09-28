import 'package:dino_hatch/model/entity/egg_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/egg_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class EggRepository extends BaseRepository<EggEntity> implements IEggRepository {
  EggRepository() : super(DatabaseName.dinoHatch);
  @override
  Future<List<EggEntity>> getAllEgg() async {
    final listContact = await list(null, null, null, null, null);
    return listContact;
  }
}
