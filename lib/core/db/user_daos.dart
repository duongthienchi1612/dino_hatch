import 'package:sqflite/sqflite.dart';
import 'package:dino_hatch/core/db/user_database.dart';
import 'package:dino_hatch/core/models/user_models.dart';

class LevelsDao {
  LevelsDao._();
  static final LevelsDao instance = LevelsDao._();

  Future<Level?> getById(int id) async {
    final Database db = await UserDatabase.instance.database;
    final rows = await db.query('levels', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Level.fromMap(rows.first);
  }

  Future<void> upsert(Level level) async {
    final Database db = await UserDatabase.instance.database;
    await db.insert('levels', level.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class EggsDao {
  EggsDao._();
  static final EggsDao instance = EggsDao._();

  Future<void> upsert(Egg egg) async {
    final Database db = await UserDatabase.instance.database;
    await db.insert('eggs', egg.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Egg>> listAll() async {
    final Database db = await UserDatabase.instance.database;
    final rows = await db.query('eggs', orderBy: 'update_at DESC');
    return rows.map(Egg.fromMap).toList();
  }
}

class DinosaurDao {
  DinosaurDao._();
  static final DinosaurDao instance = DinosaurDao._();

  Future<void> upsert(Dinosaur dino) async {
    final Database db = await UserDatabase.instance.database;
    await db.insert('dinosaur', dino.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Dinosaur>> listAll() async {
    final Database db = await UserDatabase.instance.database;
    final rows = await db.query('dinosaur', orderBy: 'created_at DESC');
    return rows.map(Dinosaur.fromMap).toList();
  }
}

class SanctuaryDao {
  SanctuaryDao._();
  static final SanctuaryDao instance = SanctuaryDao._();

  Future<void> upsert(Sanctuary s) async {
    final Database db = await UserDatabase.instance.database;
    await db.insert('sanctuary', s.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Sanctuary>> listAll() async {
    final Database db = await UserDatabase.instance.database;
    final rows = await db.query('sanctuary', orderBy: 'update_at DESC');
    return rows.map(Sanctuary.fromMap).toList();
  }
}


