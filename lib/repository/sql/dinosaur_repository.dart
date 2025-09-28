import 'package:dino_hatch/model/entity/dinosaur_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/dinosaur_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class DinosaurRepository extends BaseRepository<DinosaurEntity> implements IDinosaurRepository {
  DinosaurRepository() : super(DatabaseName.dinoHatch);
  @override
  Future<List<DinosaurEntity>> getAllDinosaur() async {
    final listContact = await list(null, null, null, null, null);
    return listContact;
  }
}
