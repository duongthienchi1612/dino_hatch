import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'egg_entity.g.dart';

enum EggState { incubating, hatched }

@JsonSerializable()
class EggEntity extends CoreEntity {
  @JsonKey(name: 'species_id')
  final int? speciesId;
  final String? state;
  @JsonKey(name: 'start_time')
  final DateTime? startTime;
  @JsonKey(name: 'hatch_time')
  final DateTime? hatchTime; // start_time + duration (incubation_time)

  EggEntity({this.speciesId, this.state, this.startTime, this.hatchTime});

  factory EggEntity.fromJson(Map<String, dynamic> json) => _$EggEntityFromJson(json);

  @override
  String get table => DatabaseTable.eggs;

  @override
  Map<String, dynamic> toJson() => _$EggEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = EggEntity.fromJson(json);
    return entity as T;
  }
}
