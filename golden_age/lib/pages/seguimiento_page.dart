import 'package:flutter/material.dart';
import 'package:golden_age/repository/firebase_api.dart';

class SeguimientoPage extends StatefulWidget {
  const SeguimientoPage({Key? key}) : super(key: key);

  @override
  State<SeguimientoPage> createState() => _SeguimientoPageState();
}

class _SeguimientoPageState extends State<SeguimientoPage> {
  final FirebaseApi _firestore = FirebaseApi();
  final ScrollController _scrollController = ScrollController(); // Controlador para el scroll
  DateTime selectedDate = DateTime.now(); // Día seleccionado
  List<Map<String, dynamic>> exerciseData = []; // Datos de ejercicios

  @override
  void initState() {
    super.initState();
    loadSeguimientoData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedDay(); // Realizar scroll al día actual
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Liberar el controlador cuando no se use
    super.dispose();
  }

  Future<void> loadSeguimientoData() async {
    try {
      final data = await _firestore.fetchExerciseData(selectedDate);
      setState(() {
        exerciseData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void scrollToSelectedDay() {
    final daysInMonth = List.generate(
      DateTime(selectedDate.year, selectedDate.month + 1, 0).day,
      (index) => index + 1,
    );
    final selectedIndex = daysInMonth.indexOf(selectedDate.day);
    if (selectedIndex != -1) {
      final position = selectedIndex * 50.0; // Asumiendo que cada día tiene un ancho de 50
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = List.generate(
      DateTime(selectedDate.year, selectedDate.month + 1, 0).day,
      (index) => DateTime(selectedDate.year, selectedDate.month, index + 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento'),
      ),
      body: Column(
        children: [
          // Fila con los días del mes
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController, // Vincular el controlador
            child: Row(
              children: daysInMonth.map((day) {
                // Verificar si hay datos para el día actual
                final hasData = exerciseData.any((exercise) {
                  final timestamp = (exercise['timestamp'] ).toDate();
                  return timestamp.year == day.year &&
                      timestamp.month == day.month &&
                      timestamp.day == day.day;
                });

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = day;
                      loadSeguimientoData();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasData
                          ? Colors.green
                          : Colors.grey, // Verde si hay datos, gris si no
                      border: Border.all(
                        color: day == selectedDate ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: day == selectedDate ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Contenido del día seleccionado
          Expanded(
            child: exerciseData.isEmpty
                ? const Center(
                    child: Text('No se realizó ejercicio este día.'),
                  )
                : ListView.builder(
                    itemCount: exerciseData.length,
                    itemBuilder: (context, index) {
                      final exercise = exerciseData[index];

                      // Verifica que los ejercicios sean de la fecha seleccionada
                      final timestamp = (exercise['timestamp'] ).toDate();
                      if (timestamp.year != selectedDate.year ||
                          timestamp.month != selectedDate.month ||
                          timestamp.day != selectedDate.day) {
                        return const SizedBox.shrink();
                      }

                      final totalReps = (exercise['series'] as List<dynamic>)
                          .fold<int>(0, (sum, serie) {
                        if (serie is Map<String, dynamic> &&
                            serie['repetitions'] is int) {
                          return sum + (serie['repetitions'] as int);
                        }
                        return sum;
                      });

                      final score = totalReps * 5;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['exerciseName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  'Grupo Muscular: ${exercise['muscleGroup']}'),
                              Text(
                                  'Tiempo de Descanso: ${exercise['restTime']} seg'),
                              Text('Puntaje: $score puntos'),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (exercise['series'] as List<dynamic>)
                                    .map<Widget>((serie) => Text(
                                          'Serie: ${serie['repetitions']} repeticiones',
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
