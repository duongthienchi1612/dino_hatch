class Era {
  final int id;
  final String name;

  const Era({required this.id, required this.name});

  factory Era.fromMap(Map<String, Object?> map) {
    return Era(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
      };
}

class Species {
  final int id;
  final String name;
  final int eraId;
  final String? description;
  final int dnaRequired;
  final int incubationTime;
  final String? modelFile;

  const Species({
    required this.id,
    required this.name,
    required this.eraId,
    this.description,
    required this.dnaRequired,
    required this.incubationTime,
    this.modelFile,
  });

  factory Species.fromMap(Map<String, Object?> map) {
    return Species(
      id: map['id'] as int,
      name: map['name'] as String,
      eraId: map['era_id'] as int,
      description: map['description'] as String?,
      dnaRequired: map['dna_required'] as int,
      incubationTime: map['incubation_time'] as int,
      modelFile: map['model_file'] as String?,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'era_id': eraId,
        'description': description,
        'dna_required': dnaRequired,
        'incubation_time': incubationTime,
        'model_file': modelFile,
      };
}


