import 'package:get_it/get_it.dart';

import 'interface/master_data/era_interface_repository.dart';
import 'interface/master_data/species_interface_repository.dart';
import 'master_data/era_repository.dart';
import 'master_data/species_repository.dart';

class RepositoryDependencies {
  static void init(GetIt injector) {
    injector.registerLazySingleton<ISpeciesRepository>(() => SpecieRepository());
    injector.registerLazySingleton<IEraRepository>(() => EraRepository());
  }
}
