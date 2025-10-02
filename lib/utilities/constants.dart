class DatabaseName {
  DatabaseName._();
  static const dinoHatch = 'dino_hatch.db';
  static const masterData = 'master_data.db';
}

class DatabaseTable {
  DatabaseTable._();
  // masterdata table
  static const species = 'species';
  static const era = 'era';
  static const level = 'level';
  static const level_obstacles = 'level_obstacles';
  // user table
  static const user_levels = 'user_levels';
  static const eggs = 'eggs';
  static const dinosaur = 'dinosaur';
  static const sanctuary = 'sanctuary';
  // other
  static const sqlSemiColonEncode = r'\003B';
}

class PreferenceKey {
  PreferenceKey._();
  static const language = 'LANGUAGE';
}