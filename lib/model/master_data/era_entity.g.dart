// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'era_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraEntity _$EraEntityFromJson(Map<String, dynamic> json) => EraEntity(
  id: (json['id'] as num?)?.toInt(),
  nameVi: json['name_vi'] as String?,
  nameEn: json['name_en'] as String?,
);

Map<String, dynamic> _$EraEntityToJson(EraEntity instance) => <String, dynamic>{
  'id': instance.id,
  'name_vi': instance.nameVi,
  'name_en': instance.nameEn,
};
