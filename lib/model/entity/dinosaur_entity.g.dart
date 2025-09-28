// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dinosaur_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DinosaurEntity _$DinosaurEntityFromJson(Map<String, dynamic> json) =>
    DinosaurEntity(
        speciesId: (json['species_id'] as num?)?.toInt(),
        name: json['name'] as String?,
        hunger: (json['hunger'] as num?)?.toInt(),
        happiness: (json['happiness'] as num?)?.toInt(),
      )
      ..id = json['id'] as String?
      ..createDate = json['create_date'] == null
          ? null
          : DateTime.parse(json['create_date'] as String)
      ..updateDate = json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String);

Map<String, dynamic> _$DinosaurEntityToJson(DinosaurEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_date': instance.createDate?.toIso8601String(),
      'update_date': instance.updateDate?.toIso8601String(),
      'species_id': instance.speciesId,
      'name': instance.name,
      'hunger': instance.hunger,
      'happiness': instance.happiness,
    };
