enum LevelState { locked, unlocked, completed }

class Level {
  final int id;
  final DateTime updateAt;
  final int world;
  final LevelState state;
  final int star;
  final int score;

  const Level({
    required this.id,
    required this.updateAt,
    required this.world,
    required this.state,
    required this.star,
    required this.score,
  });

  factory Level.fromMap(Map<String, Object?> map) {
    return Level(
      id: map['id'] as int,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map['update_at'] as int),
      world: map['world'] as int,
      state: _levelStateFromString(map['state'] as String),
      star: map['star'] as int,
      score: map['score'] as int,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'update_at': updateAt.millisecondsSinceEpoch,
        'world': world,
        'state': state.name,
        'star': star,
        'score': score,
      };
}

LevelState _levelStateFromString(String s) {
  switch (s) {
    case 'locked':
      return LevelState.locked;
    case 'unlocked':
      return LevelState.unlocked;
    case 'completed':
      return LevelState.completed;
  }
  return LevelState.locked;
}

enum EggState { incubating, hatched }

class Egg {
  final int id;
  final DateTime updateAt;
  final int speciesId;
  final EggState state;
  final DateTime? startTime;
  final DateTime? hatchTime;

  const Egg({
    required this.id,
    required this.updateAt,
    required this.speciesId,
    required this.state,
    this.startTime,
    this.hatchTime,
  });

  factory Egg.fromMap(Map<String, Object?> map) {
    return Egg(
      id: map['id'] as int,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map['update_at'] as int),
      speciesId: map['species_id'] as int,
      state: (map['state'] as String) == 'hatched'
          ? EggState.hatched
          : EggState.incubating,
      startTime: (map['start_time'] as int?) != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int)
          : null,
      hatchTime: (map['hatch_time'] as int?) != null
          ? DateTime.fromMillisecondsSinceEpoch(map['hatch_time'] as int)
          : null,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'update_at': updateAt.millisecondsSinceEpoch,
        'species_id': speciesId,
        'state': state == EggState.hatched ? 'hatched' : 'incubating',
        'start_time': startTime?.millisecondsSinceEpoch,
        'hatch_time': hatchTime?.millisecondsSinceEpoch,
      };
}

class Dinosaur {
  final int id;
  final DateTime updateAt;
  final int speciesId;
  final String? name;
  final int hunger; // 0..100
  final int happiness; // 0..100
  final DateTime createdAt;

  const Dinosaur({
    required this.id,
    required this.updateAt,
    required this.speciesId,
    this.name,
    required this.hunger,
    required this.happiness,
    required this.createdAt,
  });

  factory Dinosaur.fromMap(Map<String, Object?> map) {
    return Dinosaur(
      id: map['id'] as int,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map['update_at'] as int),
      speciesId: map['species_id'] as int,
      name: map['name'] as String?,
      hunger: map['hunger'] as int,
      happiness: map['happiness'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'update_at': updateAt.millisecondsSinceEpoch,
        'species_id': speciesId,
        'name': name,
        'hunger': hunger,
        'happiness': happiness,
        'created_at': createdAt.millisecondsSinceEpoch,
      };
}

class Sanctuary {
  final int id;
  final DateTime updateAt;
  final int dinoId;
  final int? timeIm; // timestamp ms (spec says time_im)
  final String status;

  const Sanctuary({
    required this.id,
    required this.updateAt,
    required this.dinoId,
    this.timeIm,
    required this.status,
  });

  factory Sanctuary.fromMap(Map<String, Object?> map) {
    return Sanctuary(
      id: map['id'] as int,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map['update_at'] as int),
      dinoId: map['dino_id'] as int,
      timeIm: map['time_im'] as int?,
      status: map['status'] as String,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'update_at': updateAt.millisecondsSinceEpoch,
        'dino_id': dinoId,
        'time_im': timeIm,
        'status': status,
      };
}


