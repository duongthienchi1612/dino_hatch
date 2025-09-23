import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  UserDatabase._();
  static final UserDatabase instance = UserDatabase._();
  Database? _db;

  Future<Database> get database async {
    final Database? existing = _db;
    if (existing != null) return existing;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'user.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createIndices(db);
        }
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE levels (
        id INTEGER PRIMARY KEY,
        update_at INTEGER NOT NULL,
        world INTEGER NOT NULL,
        state TEXT NOT NULL,
        star INTEGER NOT NULL,
        score INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE eggs (
        id INTEGER PRIMARY KEY,
        update_at INTEGER NOT NULL,
        species_id INTEGER NOT NULL,
        state TEXT NOT NULL,
        start_time INTEGER,
        hatch_time INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE dinosaur (
        id INTEGER PRIMARY KEY,
        update_at INTEGER NOT NULL,
        species_id INTEGER NOT NULL,
        name TEXT,
        hunger INTEGER NOT NULL,
        happiness INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE sanctuary (
        id INTEGER PRIMARY KEY,
        update_at INTEGER NOT NULL,
        dino_id INTEGER NOT NULL,
        time_im INTEGER,
        status TEXT NOT NULL
      );
    ''');
    await _createIndices(db);
  }

  Future<void> _createIndices(Database db) async {
    await db.execute('CREATE INDEX IF NOT EXISTS idx_levels_world ON levels(world);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_levels_state ON levels(state);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_eggs_species_id ON eggs(species_id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_dino_species_id ON dinosaur(species_id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sanctuary_dino_id ON sanctuary(dino_id);');
  }
}


