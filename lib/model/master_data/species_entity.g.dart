// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeciesEntity _$SpeciesEntityFromJson(Map<String, dynamic> json) =>
    SpeciesEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      eraId: (json['era_id'] as num?)?.toInt(),
      sizeVi: json['size_vi'] as String?,
      sizeEn: json['size_en'] as String?,
      weightVi: json['weight_vi'] as String?,
      weightEn: json['weight_en'] as String?,
      descriptionVi: json['description_vi'] as String?,
      descriptionEn: json['description_en'] as String?,
      funFactVi: json['fun_fact_vi'] as String?,
      funFactEn: json['fun_fact_en'] as String?,
      dnaRequired: (json['dna_required'] as num?)?.toInt(),
      incubationTime: (json['incubation_time'] as num?)?.toInt(),
      modelFile: json['model_file'] as String?,
    );

Map<String, dynamic> _$SpeciesEntityToJson(SpeciesEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'era_id': instance.eraId,
      'size_vi': instance.sizeVi,
      'size_en': instance.sizeEn,
      'weight_vi': instance.weightVi,
      'weight_en': instance.weightEn,
      'description_vi': instance.descriptionVi,
      'description_en': instance.descriptionEn,
      'fun_fact_vi': instance.funFactVi,
      'fun_fact_en': instance.funFactEn,
      'dna_required': instance.dnaRequired,
      'incubation_time': instance.incubationTime,
      'model_file': instance.modelFile,
    };
