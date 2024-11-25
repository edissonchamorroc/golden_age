import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:golden_age/models/Exercise.dart';
import 'package:golden_age/pages/exercise_detail_page.dart';
import 'package:golden_age/repository/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({super.key});

  @override
  State<CreateRoutinePage> createState() => _CreateRutinaPageState();
}

class _CreateRutinaPageState extends State<CreateRoutinePage> {
  final FirebaseApi _firebaseService = FirebaseApi();
  String? selectedMuscleGroup;
  List<Exercise> exercises = [];
  bool isLoading = false;
  List<Exercise> rutinadesing = [];
  final List<String> muscleGroups = [
    'Pecho',
    'Espalda',
    'Piernas',
    'Brazos',
    'Hombros',
    'Abdominales',
  ];

  Future<void> allExercises() async {
    if (selectedMuscleGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un grupo muscular')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Exercise>? fetchedExercises = await _firebaseService.allExercises(
        selectedMuscleGroup!,
      );

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

  Future<void> saveExerciseToLocalStorage(Exercise exercise) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String exerciseJson = jsonEncode(exercise.toJson());
    if (exerciseJson == prefs.getString('selectedExercise')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya ingresaste a este ejercicio')),
      );
    }
    await prefs.setString('selectedExercise', exerciseJson);
  }

  void navigateToExerciseDetail(Exercise exercise) async {
    await saveExerciseToLocalStorage(exercise);
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diseña tu Rutina'),
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
              onPressed: allExercises,
              child: const Text('Ejercicios disponibles'),
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
                                  'Descripción: ${exercise.description}',
                                ),
                                onTap: () {
                                  setState(() {
                                    if (!rutinadesing.contains(exercise)) {
                                      rutinadesing.add(exercise);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${exercise.name} agregado a la rutina.'),
                                        ),
                                      );
                                    }
                                  });
                                },
                                onLongPress: () {
                                  setState(() {
                                    if (rutinadesing.contains(exercise)) {
                                      rutinadesing.remove(exercise);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${exercise.name} eliminado de la rutina.'),
                                        ),
                                      );
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (rutinadesing.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La rutina está vacía.'),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Rutina Diseñada'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: rutinadesing.length,
                            itemBuilder: (context, index) {
                              final exercise = rutinadesing[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(
                                    exercise.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Descripción: ${exercise.description}',
                                  ),
                                  onTap: () =>
                                      navigateToExerciseDetail(exercise),
                                ),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Visualizar Rutina'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
