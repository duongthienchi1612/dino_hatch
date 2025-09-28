import 'package:dino_hatch/model/entity/sanctuary_entity.dart';
import 'package:dino_hatch/repository/base/interface.dart';

abstract class ISanctuaryRepository extends IBaseRepository<SanctuaryEntity> {
  Future<List<SanctuaryEntity>> getAllSanctuary();
}
