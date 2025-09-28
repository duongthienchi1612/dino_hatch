
import 'package:dino_hatch/model/entity/egg_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

abstract class IEggRepository extends IBaseRepository<EggEntity> {
  Future<List<EggEntity>> getAllEgg();
}
