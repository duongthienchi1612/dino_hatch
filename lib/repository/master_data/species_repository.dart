import 'package:dino_hatch/model/master_data/species_entity.dart';
import 'package:dino_hatch/repository/base/base_repository.dart';
import 'package:dino_hatch/repository/interface/master_data/species_interface_repository.dart';
import 'package:dino_hatch/utilities/constants.dart';

class SpecieRepository extends BaseReadRepository<SpeciesEntity> implements ISpeciesRepository{
  SpecieRepository() : super(DatabaseName.masterData);
}