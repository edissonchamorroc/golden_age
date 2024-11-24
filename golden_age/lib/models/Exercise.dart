class Exercise {
  final String name;
  final String muscleGroup;
  final String nivel;
  final int? repetitions; 
  final int? series; 
  final double? weight; 
  final int? restTime; 
  final String description; 

  Exercise({
    required this.name,
    required this.muscleGroup,
    required this.nivel,
    this.repetitions,
    this.series,
    this.weight,
    this.restTime,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    
    return Exercise(
      name: json['name'] ?? 'Sin nombre',
      muscleGroup:json['muscleGroup']?? 'Sin grupo muscular',
      nivel: json['nivel'] ?? 'Sin nivel',
      repetitions: json['repetitions'],
      series: json['series'],
      weight: (json['weight'] as num?)?.toDouble(),
      restTime: json['restTime'],
      description: json['description'] ?? 'Sin descripcion',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'muscleGroup':muscleGroup,
      'nivel': nivel,
      'repetitions': repetitions,
      'series': series,
      'weight': weight,
      'restTime': restTime,
      'description': description,
    };
  }

}
