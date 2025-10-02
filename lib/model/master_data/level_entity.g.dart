// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelEntity _$LevelEntityFromJson(Map<String, dynamic> json) => LevelEntity(
  id: (json['id'] as num?)?.toInt(),
  eraId: (json['era_id'] as num?)?.toInt(),
  winMode: json['win_mode'] as String?,
  obstacleCount: (json['obstacle_count'] as num?)?.toInt(),
  speciesId: (json['species_id'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toInt(),
);

Map<String, dynamic> _$LevelEntityToJson(LevelEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'era_id': instance.eraId,
      'win_mode': instance.winMode,
      'obstacle_count': instance.obstacleCount,
      'species_id': instance.speciesId,
      'amount': instance.amount,
    };
