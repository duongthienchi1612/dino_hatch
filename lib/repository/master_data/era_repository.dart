import 'package:dino_hatch/model/master_data/era_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/master_data/era_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class EraRepository extends BaseReadRepository<EraEntity> implements IEraRepository {
  EraRepository() : super(DatabaseName.masterData);
}
