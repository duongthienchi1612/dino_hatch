import 'package:sqflite/sqflite.dart';
import 'package:dino_hatch/core/db/master_database.dart';
import 'package:dino_hatch/core/models/master_models.dart';

class MasterDao {
  MasterDao._();
  static final MasterDao instance = MasterDao._();

  Future<List<Era>> listEras() async {
    final Database db = await MasterDatabase.instance.database;
    final rows = await db.query('era', orderBy: 'id ASC');
    return rows.map((m) => Era.fromMap(m)).toList();
  }

  Future<List<Species>> listSpecies({int? eraId}) async {
    final Database db = await MasterDatabase.instance.database;
    final rows = await db.query(
      'species',
      where: eraId != null ? 'era_id = ?' : null,
      whereArgs: eraId != null ? [eraId] : null,
      orderBy: 'id ASC',
    );
    return rows.map((m) => Species.fromMap(m)).toList();
  }

  Future<void> upsertSpecies(Species s) async {
    final Database db = await MasterDatabase.instance.database;
    await db.insert('species', s.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}


