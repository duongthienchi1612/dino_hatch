// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sanctuary_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SanctuaryEntity _$SanctuaryEntityFromJson(Map<String, dynamic> json) =>
    SanctuaryEntity(
        dinoId: (json['dino_id'] as num?)?.toInt(),
        timeIm: (json['time_im'] as num?)?.toInt(),
        status: json['status'] as String?,
      )
      ..id = json['id'] as String?
      ..createDate = json['create_date'] == null
          ? null
          : DateTime.parse(json['create_date'] as String)
      ..updateDate = json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String);

Map<String, dynamic> _$SanctuaryEntityToJson(SanctuaryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_date': instance.createDate?.toIso8601String(),
      'update_date': instance.updateDate?.toIso8601String(),
      'dino_id': instance.dinoId,
      'time_im': instance.timeIm,
      'status': instance.status,
    };
