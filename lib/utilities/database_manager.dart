import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  final String path;
  late Database database;

  DatabaseManager({required this.path});

  Future open() async {
    database = await openDatabase(path);
  }

  Future close() async {
    await database.close();
  }

  Future<int> getVersion() async {
    return database.getVersion();
  }

  Future setVersion(int version) async {
    await database.setVersion(version);
  }

  Future exec(String sql) async {
    await database.execute(sql);
  }

  Future delete(CoreEntity item) async {
    await database.delete(item.table, where: 'id = ?', whereArgs: <String?>[item.id]);
  }

  Future insert(CoreEntity item) async {
    await database.insert(item.table, item.toJson());
  }

  Future update(CoreEntity item) async {
    await database.update(item.table, item.toJson(), where: 'id = ?', whereArgs: <String?>[item.id]);
  }

  Future<List<Map<String, dynamic>>> list(String query, [final List<String> args = const <String>[]]) async {
    final queryResult = await database.rawQuery(query, args);
    return queryResult.toList();
  }
}
