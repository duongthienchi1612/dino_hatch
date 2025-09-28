import 'package:json_annotation/json_annotation.dart';

abstract class CoreReadEntity {
  String get table;
  Map<String, dynamic> toJson();
  external T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json);
}

abstract class CoreEntity extends CoreReadEntity {
  String? id;

  @JsonKey(name: 'create_date')
  DateTime? createDate;
  
  @JsonKey(name: 'update_date')
  DateTime? updateDate;
}
