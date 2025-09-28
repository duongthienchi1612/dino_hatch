import 'package:basic_utils/basic_utils.dart';
import 'package:uuid/uuid.dart';

import '../../dependencies.dart';
import '../../model/base/base_entity.dart';
import '../../utilities/database_factory.dart';
import 'interface.dart';

abstract class BaseReadRepository<T extends CoreReadEntity> implements IBaseReadRepository<T> {
  final String databaseName;
  final dbFactory = injector.get<DatabaseFactory>();

  BaseReadRepository(this.databaseName);

  @override
  Future<T?> getById(String? id) async {
    if (StringUtils.isNullOrEmpty(id)) {
      return null;
    }
    final condition = "Id = '$id'";
    final items = await list(condition, null, null, null, null);
    return items.isEmpty ? null : items[0];
  }

  @override
  Future<List<T>> listAll() async {
    return list(null, null, null, null, null, []);
  }

  @override
  Future<List<T>> list(String? where, String? orderBy, bool? asc, int? pageIndex, int? pageSize,
      [final List<String> args = const <String>[]]) async {
    return listSelected(null, where, orderBy, asc, pageIndex, pageSize, args);
  }

  Future<List<T>> listSelected(String? columns, String? where, String? orderBy, bool? asc, int? pageIndex, int? pageSize,
      [final List<String> args = const <String>[]]) async {
    final item = injector.get<T>();
    final selected = StringUtils.isNullOrEmpty(columns) ? '*' : columns;
    var query = 'select $selected from ${item.table} ';

    if (where != null) {
      query += 'where $where ';
    }

    if (orderBy != null) {
      final direction = asc == true ? 'ASC' : 'DESC';
      query += 'order by $orderBy $direction ';
    }

    if (pageIndex != null && pageSize != null) {
      final skip = (pageIndex - 1) * pageSize;
      final limit = pageSize;
      query += 'LIMIT $limit OFFSET $skip ';
    }
    return listRaw(query, item.fromJsonConvert, args);
  }

  @override
  Future<List<T>> listRaw<T>(
      String query,
      T Function(
        Map<String, dynamic>,
      ) mapper,
      [final List<String> args = const <String>[]]) async {
    final database = await dbFactory.getDatabase(databaseName);
    final list = await database.list(query, args);
    return list.map((f) => mapper(f)).toList();
  }
}

abstract class BaseRepository<T extends CoreEntity> extends BaseReadRepository<T> implements IBaseRepository<T> {
  BaseRepository(super.databaseName);

  final Uuid uuid = const Uuid();

  @override
  Future insert(T? item) async {
    if (item == null) {
      return;
    }
    final date = DateTime.now().toUtc();
    item.id = item.id ?? uuid.v4();
    item.createDate = date;
    item.updateDate = date;
    final database = await dbFactory.getUserDatabase();
    await database.insert(item);
  }

  @override
  Future update(T? item) async {
    if (item == null) {
      return;
    }
    final date = DateTime.now().toUtc();
    item.updateDate = date;
    final database = await dbFactory.getUserDatabase();
    await database.update(item);
  }

  @override
  Future delete(T? item) async {
    if (item == null) {
      return;
    }
    final database = await dbFactory.getUserDatabase();
    await database.delete(item);
  }

  Future execute(String sql) async {
    final database = await dbFactory.getUserDatabase();
    await database.exec(sql);
  }
}
