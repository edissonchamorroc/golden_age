import 'package:flutter/material.dart';
import 'package:golden_age/models/Exercise.dart';
import 'package:golden_age/repository/firebase_api.dart';

class GenerateRoutinePage extends StatefulWidget {
  const GenerateRoutinePage({super.key});

  @override
  State<GenerateRoutinePage> createState() => _GenerateRoutinePageState();
}

class _GenerateRoutinePageState extends State<GenerateRoutinePage> {
  final FirebaseApi _firebaseService = FirebaseApi();
  String? selectedMuscleGroup;
  String? selectedLevel;
  List<Exercise> exercises = [];
  bool isLoading = false;

  final List<String> muscleGroups = [
    'Pecho',
    'Espalda',
    'Piernas',
    'Brazos',
    'Hombros',
    'Abdominales',
  ];

  Future<void> fetchExercises() async {
    if (selectedMuscleGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un grupo muscular y nivel')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Exercise>? fetchedExercises =
          await _firebaseService.fetchExercises(selectedMuscleGroup!);

      setState(() {
        exercises = fetchedExercises!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener ejercicios: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de Rutina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona un grupo muscular:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMuscleGroup,
              items: muscleGroups.map((muscle) {
                return DropdownMenuItem(
                  value: muscle,
                  child: Text(muscle),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMuscleGroup = value;
                });
              },
              hint: const Text('Elige un grupo muscular'),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchExercises,
              child: const Text('Generar Rutina'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : exercises.isEmpty
                    ? const Center(child: Text('No se encontraron ejercicios'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  exercise.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Repeticiones: ${exercise.repetitions}\n'
                                  'Peso: ${exercise.weight} kg\n'
                                  'Descanso: ${exercise.restTime} seg\n'
                                  'Descripción: ${exercise.description}',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
