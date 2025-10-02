import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level_obstacles_entity.g.dart';

@JsonSerializable()
class LevelObstaclesEntity extends CoreReadEntity {
  @JsonKey(name: 'level_id')
  final int? levelId;

  @JsonKey(name: 'row')
  final int? row;

  @JsonKey(name: 'col')
  final int? column;

  LevelObstaclesEntity({this.levelId, this.row, this.column});

  @override
  String get table => DatabaseTable.level_obstacles;

  factory LevelObstaclesEntity.fromJson(Map<String, dynamic> json) {
    return _$LevelObstaclesEntityFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$LevelObstaclesEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = LevelObstaclesEntity.fromJson(json);
    return entity as T;
  }
}
