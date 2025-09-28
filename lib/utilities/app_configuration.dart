import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';

class AppConfiguration {
  Future<bool> init() async {
    final Map<String, dynamic> localConfig = jsonDecode(await _loadFromAssetConfig('assets/cfg/app_settings.json'));
    GlobalConfiguration().loadFromMap(localConfig);
    return true;
  }

  Future<String> _loadFromAssetConfig(String fileName) async {
    final path = fileName;
    final content = await rootBundle.loadString(path);
    return content;
  }

  int? getInt(String key) {
    final num = GlobalConfiguration().get(key);
    if (num is int) {
      return num;
    }
    return num?.toInt();
  }

  double? getDouble(String key) {
    final num = GlobalConfiguration().get(key);
    if (num is double) {
      return num;
    }
    return double.tryParse(num);
  }

  String? getString(String key, {isEncrypted = false}) {
    final text = GlobalConfiguration().get(key);
    if (text == null) {
      return null;
    }
    return text;
  }

  int? get dbVersion => getInt('dbVersion');
}
