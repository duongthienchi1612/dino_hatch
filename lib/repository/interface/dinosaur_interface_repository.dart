import 'package:dino_hatch/model/entity/dinosaur_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

abstract class IDinosaurRepository extends IBaseRepository<DinosaurEntity> {
  Future<List<DinosaurEntity>> getAllDinosaur();
}
