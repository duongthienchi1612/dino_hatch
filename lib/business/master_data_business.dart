import 'package:dino_hatch/dependencies.dart';
import 'package:dino_hatch/model/master_data/era_entity.dart';
import 'package:dino_hatch/model/master_data/species_entity.dart';
import 'package:dino_hatch/repository/interface/master_data/era_interface_repository.dart';
import 'package:dino_hatch/repository/interface/master_data/species_interface_repository.dart';

class MasterDataBusiness {
  MasterDataBusiness();

  final _speciesRepository = injector.get<ISpeciesRepository>();
  final _eraRepository = injector.get<IEraRepository>();

  List<SpeciesEntity>? species;
  List<EraEntity>? era;

  Future init() async {
    species = await _speciesRepository.listAll();
    era = await _eraRepository.listAll();
  }
}
