import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sanctuary_entity.g.dart';

@JsonSerializable()
class SanctuaryEntity extends CoreEntity {
  @JsonKey(name: 'dino_id')
  final int? dinoId;
  @JsonKey(name: 'time_im')
  final int? timeIm; // timestamp ms (spec says time_im)
  @JsonKey(name: 'status')
  final String? status;

  SanctuaryEntity({this.dinoId, this.timeIm, this.status});

  factory SanctuaryEntity.fromJson(Map<String, dynamic> json) => _$SanctuaryEntityFromJson(json);

  @override
  String get table => DatabaseTable.sanctuary;

  @override
  Map<String, dynamic> toJson() => _$SanctuaryEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = SanctuaryEntity.fromJson(json);
    return entity as T;
  }
}
