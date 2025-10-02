// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_obstacles_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelObstaclesEntity _$LevelObstaclesEntityFromJson(
  Map<String, dynamic> json,
) => LevelObstaclesEntity(
  levelId: (json['level_id'] as num?)?.toInt(),
  row: (json['row'] as num?)?.toInt(),
  column: (json['col'] as num?)?.toInt(),
);

Map<String, dynamic> _$LevelObstaclesEntityToJson(
  LevelObstaclesEntity instance,
) => <String, dynamic>{
  'level_id': instance.levelId,
  'row': instance.row,
  'col': instance.column,
};
