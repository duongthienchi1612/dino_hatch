// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_level_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLevelEntity _$UserLevelEntityFromJson(Map<String, dynamic> json) =>
    UserLevelEntity(
        world: (json['world'] as num?)?.toInt(),
        state: json['state'] as String?,
        star: (json['star'] as num?)?.toInt(),
        score: (json['score'] as num?)?.toInt(),
      )
      ..id = json['id'] as String?
      ..createDate = json['create_date'] == null
          ? null
          : DateTime.parse(json['create_date'] as String)
      ..updateDate = json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String);

Map<String, dynamic> _$UserLevelEntityToJson(UserLevelEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_date': instance.createDate?.toIso8601String(),
      'update_date': instance.updateDate?.toIso8601String(),
      'world': instance.world,
      'state': instance.state,
      'star': instance.star,
      'score': instance.score,
    };
