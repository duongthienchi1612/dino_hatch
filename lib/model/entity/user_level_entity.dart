import 'package:dino_hatch/model/base/base_entity.dart';
import 'package:dino_hatch/utilities/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_level_entity.g.dart';

enum LevelState { locked, unlocked, completed }

@JsonSerializable()
class UserLevelEntity extends CoreEntity {
  final int? world; // triasic = 1, jurassic = 2, cretaceous = 3
  final String? state; // locked, unlocked, completed
  final int? star;
  final int? score;

  UserLevelEntity({this.world, this.state, this.star, this.score});

  factory UserLevelEntity.fromJson(Map<String, dynamic> json) => _$UserLevelEntityFromJson(json);

  @override
  String get table => DatabaseTable.user_levels;

  @override
  Map<String, dynamic> toJson() => _$UserLevelEntityToJson(this);

  @override
  T fromJsonConvert<T extends CoreReadEntity>(Map<String, dynamic> json) {
    final entity = UserLevelEntity.fromJson(json);
    return entity as T;
  }
}
