import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level_entity.g.dart';

@JsonSerializable()
class LevelEntity extends CoreReadEntity {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'era_id')
  final int? eraId;

  @JsonKey(name: 'win_mode')
  final String? winMode;

  @JsonKey(name: 'obstacle_count')
  final int? obstacleCount;

  @JsonKey(name: 'species_id')
  final int? speciesId;

  @JsonKey(name: 'amount')
  final int? amount;

  LevelEntity({this.id, this.eraId, this.winMode, this.obstacleCount, this.speciesId, this.amount});

  @override
  String get table => DatabaseTable.level;

  factory LevelEntity.fromJson(Map<String, dynamic> json) {
    return _$LevelEntityFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$LevelEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = LevelEntity.fromJson(json);
    return entity as T;
  }
}
