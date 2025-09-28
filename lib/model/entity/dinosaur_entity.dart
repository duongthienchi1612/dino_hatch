import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dinosaur_entity.g.dart';

enum LevelState { locked, unlocked, completed }

@JsonSerializable()
class DinosaurEntity extends CoreEntity {
  @JsonKey(name: 'species_id')
  final int? speciesId;
  final String? name; // user đặt tên
  final int? hunger; // 0..100
  final int? happiness; // 0..100

  DinosaurEntity({this.speciesId, this.name, this.hunger, this.happiness});

  factory DinosaurEntity.fromJson(Map<String, dynamic> json) => _$DinosaurEntityFromJson(json);

  @override
  String get table => DatabaseTable.dinosaur;

  @override
  Map<String, dynamic> toJson() => _$DinosaurEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = DinosaurEntity.fromJson(json);
    return entity as T;
  }
}
