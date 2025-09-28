import 'package:dino_hatch/utilities/constants.dart';
import 'package:dino_hatch/utilities/localization_helper.dart';
import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'species_entity.g.dart';

@JsonSerializable()
class SpeciesEntity extends CoreReadEntity {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'era_id')
  final int? eraId;

  @JsonKey(name: 'size_vi')
  final String? sizeVi;

  @JsonKey(name: 'size_en')
  final String? sizeEn;

  @JsonKey(name: 'weight_vi')
  final String? weightVi;

  @JsonKey(name: 'weight_en')
  final String? weightEn;

  @JsonKey(name: 'description_vi')
  final String? descriptionVi;

  @JsonKey(name: 'description_en')
  final String? descriptionEn;

  @JsonKey(name: 'fun_fact_vi')
  final String? funFactVi;

  @JsonKey(name: 'fun_fact_en')
  final String? funFactEn;

  @JsonKey(name: 'dna_required')
  final int? dnaRequired;

  @JsonKey(name: 'incubation_time')
  final int? incubationTime;

  @JsonKey(name: 'model_file')
  final String? modelFile;

  SpeciesEntity({
    this.id,
    this.name,
    this.eraId,
    this.sizeVi,
    this.sizeEn,
    this.weightVi,
    this.weightEn,
    this.descriptionVi,
    this.descriptionEn,
    this.funFactVi,
    this.funFactEn,
    this.dnaRequired,
    this.incubationTime,
    this.modelFile,
  });

  @override
  String get table => DatabaseTable.species;

  factory SpeciesEntity.fromJson(Map<String, dynamic> json) {
    return _$SpeciesEntityFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$SpeciesEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = SpeciesEntity.fromJson(json);
    return entity as T;
  }
}

// Extension cho AccessoryEntity
extension SpecieEntityExtension on SpeciesEntity {
  String size(BuildContext context) {
    final String languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    if (languageCode == 'vi') {
      return sizeVi ?? '';
    } else {
      return sizeEn ?? sizeVi ?? '';
    }
  }

  String weight(BuildContext context) {
    final String languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    if (languageCode == 'vi') {
      return weightVi ?? '';
    } else {
      return weightEn ?? weightVi ?? '';
    }
  }

  String description(BuildContext context) {
    final String languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    if (languageCode == 'vi') {
      return descriptionVi ?? '';
    } else {
      return descriptionEn ?? descriptionVi ?? '';
    }
  }

  String funFact(BuildContext context) {
    final String languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    if (languageCode == 'vi') {
      return funFactVi ?? '';
    } else {
      return funFactEn ?? funFactVi ?? '';
    }
  }
}
