import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MasterDatabase {
  MasterDatabase._();
  static final MasterDatabase instance = MasterDatabase._();
  Database? _db;

  Future<Database> get database async {
    final Database? existing = _db;
    if (existing != null) return existing;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'master.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createSchema(db);
        await _seedEras(db);
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
      CREATE TABLE era (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE species (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        era_id INTEGER NOT NULL,
        description TEXT,
        dna_required INTEGER NOT NULL,
        incubation_time INTEGER NOT NULL,
        model_file TEXT,
        FOREIGN KEY (era_id) REFERENCES era(id)
      );
    ''');
    await _createIndices(db);
  }

  Future<void> _seedEras(Database db) async {
    await db.insert('era', {'id': 1, 'name': 'Triassic'});
    await db.insert('era', {'id': 2, 'name': 'Jurassic'});
    await db.insert('era', {'id': 3, 'name': 'Cretaceous'});
  }

  Future<void> _createIndices(Database db) async {
    await db.execute('CREATE INDEX IF NOT EXISTS idx_species_era_id ON species(era_id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_species_name ON species(name);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_era_name ON era(name);');
  }
}


