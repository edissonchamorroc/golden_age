import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:golden_age/models/Exercise.dart';
import 'package:golden_age/repository/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({Key? key}) : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  Exercise? exercise;
  List<int> repetitions = [];
  List<String> images = [];
  final FirebaseApi _firebaseApi = FirebaseApi();

  Future<Exercise?> getExerciseFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? exerciseJson = prefs.getString('selectedExercise');
    if (exerciseJson != null) {
      final Map<String, dynamic> exerciseMap = jsonDecode(exerciseJson);
      return Exercise.fromJson(exerciseMap);
    }
    return null;
  }

  void saveRepetitionsToFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    Map<String, dynamic> seguimiento = {
      'user': userId,
      'exerciseName': exercise!.name,
      'muscleGroup': exercise!.muscleGroup,
      'restTime': exercise!.restTime,
      'series': repetitions.map((rep) => {'repetitions': rep}).toList(),
      'timestamp': Timestamp.now()
    };

    await _firebaseApi.saveSeguimiento(seguimiento);
  }

  @override
  void initState() {
    super.initState();
    getExerciseFromLocalStorage().then((data) {
      setState(() {
        exercise = data;
        repetitions = List.generate(data?.series ?? 0, (index) => 0);
        loadImages(exercise!.name.replaceAll(" ", "_"));
      });
    });
  }

  Future<void> loadImages(String exerciseName) async {
    try {
      // Obtén el manifiesto de assets
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filtra los assets por la carpeta específica
      final folderPath = 'assets/$exerciseName/';
      print(folderPath);
      final imagePaths = manifestMap.keys
          .where((path) => path.startsWith(folderPath))
          .toList();
      print(imagePaths);
      setState(() {
        images = imagePaths;
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise!.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel de imágenes
            CarouselSlider(
              items: images.map((imagePath) {
                return Image.asset(imagePath, fit: BoxFit.cover);
              }).toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      'Grupo Muscular',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(exercise!.muscleGroup),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Series',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${exercise!.series}'),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Repeticiones',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(exercise!.repetitions.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Repeticiones por serie
            Expanded(
              child: ListView.builder(
                itemCount: repetitions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Serie ${index + 1}'),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Reps',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              repetitions[index] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Botón para guardar
            ElevatedButton(
              onPressed: saveRepetitionsToFirebase,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Guardar seguimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
