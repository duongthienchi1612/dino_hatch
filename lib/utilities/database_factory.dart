import 'dart:developer';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '../dependencies.dart';
import 'app_configuration.dart';
import 'database_manager.dart';
import 'file_utility.dart';

class DatabaseFactory {
  final FileUtility fileUtility = injector.get<FileUtility>();
  final AppConfiguration config = injector.get<AppConfiguration>();

  Future initDatabase() async {
    await initLocalDatabase();
    await getUserDatabase();
    await getMasterDatabase();
  }

  Future<String> initLocalDatabase() async {
    final folderPath = await fileUtility.getCommonDatabaseFolder();
    final dbPath = join(folderPath, DatabaseName.masterData);

    final bool isExist = await File(dbPath).exists();
    if (!isExist) {
      await File(dbPath).create(recursive: true);
    }
    // copy database from asset to local
    final bytes = await rootBundle.load('assets/database/${DatabaseName.masterData}');
    await File(dbPath).writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return dbPath;
  }

  Future<DatabaseManager> getMasterDatabase() async {
    final folderPath = await fileUtility.getCommonDatabaseFolder();
    final filePath = join(folderPath, DatabaseName.masterData);
    final db = DatabaseManager(path: filePath);
    await db.open();
    return db;
  }

  Future<DatabaseManager> getUserDatabase() async {
    final folderPath = await fileUtility.getCommonDatabaseFolder();
    final filePath = join(folderPath, DatabaseName.dinoHatch);
    final db = DatabaseManager(path: filePath);
    await db.open();
    final currentVersion = await db.getVersion();
    log(db.path);
    if (currentVersion == 0) {
      await runScriptFile(db, 'assets/database/initialize.sql');
      await db.setVersion(config.dbVersion!);
      return db;
    }
    if (currentVersion < (config.dbVersion ?? 0)) {
      for (var v = currentVersion + 1; v <= (config.dbVersion ?? 0); v++) {
        final version = getVersionText(v);
        await runScriptFile(db, 'assets/database/migration/update_$version.sql');
      }
      await db.setVersion(config.dbVersion ?? 0);
    }
    return db;
  }

  Future<DatabaseManager> getDatabase(String databaseName) async {
    if (databaseName == DatabaseName.masterData) {
      return getMasterDatabase();
    } else {
      return getUserDatabase();
    }
  }

  Future runScriptFile(DatabaseManager db, String path) async {
    final text = await rootBundle.loadString(path);
    final scriptLines = text.split(';');
    if (scriptLines.isNotEmpty) {
      for (var i = 0; i < scriptLines.length; i++) {
        var finalScript = scriptLines[i].trim();
        if (StringUtils.isNullOrEmpty(finalScript)) continue;
        finalScript = finalScript.replaceAll(DatabaseTable.sqlSemiColonEncode, ';');
        await db.exec(finalScript);
      }
    }
  }

  String getVersionText(int v) {
    var version = v.toString();
    for (var i = version.length; i < 4; i++) {
      version = '0$version';
    }
    return version;
  }
}
