import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'era_entity.g.dart';

@JsonSerializable()
class EraEntity extends CoreReadEntity {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name_vi')
  final String? nameVi;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  EraEntity({this.id, this.nameVi, this.nameEn});

  @override
  String get table => DatabaseTable.era;

  factory EraEntity.fromJson(Map<String, dynamic> json) {
    return _$EraEntityFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$EraEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = EraEntity.fromJson(json);
    return entity as T;
  }
}
