import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:golden_age/pages/fixed_variable_page.dart';

class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({super.key});

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _data = DateTime.now();

  String _dateConverter(DateTime newDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(newDate);
    return dateFormatted;
  }

  final List<String> _grupos = [
    'Pecho',
    'Espalda',
    'Piernas',
    'Brazos',
    'Hombros',
    'Abdominales',
  ];
  String? _selectedGrupo;

  List<String> _seleccionados = [];

  Widget _buildCard(QueryDocumentSnapshot exercises) {
    return InkWell(
      onTap: () {
        if (!_seleccionados.contains(exercises["name"])) {
          _seleccionados.add(exercises['name']);
        }
        print("Clic en: ${exercises['name']}");
        print(_seleccionados);
      },
      onLongPress: () {
        if (_seleccionados.contains(exercises['name'])) {
          _seleccionados.remove(exercises['name']);
        }
        print("Long click en: ${exercises['name']}");
        print(_seleccionados);
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(exercises['name']),
              subtitle: Text(exercises['description']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué vas a entrenar hoy?'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedGrupo,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Grupo muscular',
                ),
                items: _grupos.map((String grupo) {
                  return DropdownMenuItem<String>(
                    value: grupo,
                    child: Text(grupo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGrupo = newValue;
                  });
                },
              ),
            ),
            Expanded(
              child: _selectedGrupo == null
                  ? const Center(
                      child: Text('Selecciona un grupo muscular'),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("ejercicios")
                          .where('muscleGroup', isEqualTo: _selectedGrupo)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                                'No hay ejercicios disponibles para este grupo.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot ejercicios =
                                snapshot.data!.docs[index];
                            return _buildCard(ejercicios);
                          },
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
