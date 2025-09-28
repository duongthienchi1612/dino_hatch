import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level_entity.g.dart';

enum LevelState { locked, unlocked, completed }

@JsonSerializable()
class LevelEntity extends CoreEntity {
  final int? world; // triasic = 1, jurassic = 2, cretaceous = 3
  final String? state; // locked, unlocked, completed
  final int? star;
  final int? score;

  LevelEntity({this.world, this.state, this.star, this.score});

  factory LevelEntity.fromJson(Map<String, dynamic> json) => _$LevelEntityFromJson(json);

  @override
  String get table => DatabaseTable.levels;

  @override
  Map<String, dynamic> toJson() => _$LevelEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = LevelEntity.fromJson(json);
    return entity as T;
  }
}
