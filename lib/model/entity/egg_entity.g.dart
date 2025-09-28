// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egg_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EggEntity _$EggEntityFromJson(Map<String, dynamic> json) =>
    EggEntity(
        speciesId: (json['species_id'] as num?)?.toInt(),
        state: json['state'] as String?,
        startTime: json['start_time'] == null
            ? null
            : DateTime.parse(json['start_time'] as String),
        hatchTime: json['hatch_time'] == null
            ? null
            : DateTime.parse(json['hatch_time'] as String),
      )
      ..id = json['id'] as String?
      ..createDate = json['create_date'] == null
          ? null
          : DateTime.parse(json['create_date'] as String)
      ..updateDate = json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String);

Map<String, dynamic> _$EggEntityToJson(EggEntity instance) => <String, dynamic>{
  'id': instance.id,
  'create_date': instance.createDate?.toIso8601String(),
  'update_date': instance.updateDate?.toIso8601String(),
  'species_id': instance.speciesId,
  'state': instance.state,
  'start_time': instance.startTime?.toIso8601String(),
  'hatch_time': instance.hatchTime?.toIso8601String(),
};
