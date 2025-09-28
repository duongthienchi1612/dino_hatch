import 'package:dino_hatch/model/entity/sanctuary_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/sanctuary_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class SanctuaryRepository extends BaseRepository<SanctuaryEntity> implements ISanctuaryRepository {
  SanctuaryRepository() : super(DatabaseName.dinoHatch);
  @override
  Future<List<SanctuaryEntity>> getAllSanctuary() async {
    final listContact = await list(null, null, null, null, null);
    return listContact;
  }
}
