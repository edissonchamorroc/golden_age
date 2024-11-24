import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'create_routine_page.dart';
import 'generate_routine_page.dart';

class RutinaPage extends StatefulWidget {
  const RutinaPage({super.key});

  @override
  State<RutinaPage> createState() => _RutinaPageState();
}

class _RutinaPageState extends State<RutinaPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Función para manejar las opciones seleccionadas en el menú desplegable.
  void _handleMenuOption(String option) {
    switch (option) {
      case 'Generar rutina automática':
        // Acción para generar una rutina automática.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenerateRoutinePage()),
        );
        break;
      case 'Crear nueva rutina':
        // Acción para crear una nueva rutina.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateRoutinePage()),
        );
        break;
      case 'Modificar rutina actual':
        // Acción para modificar la rutina actual.
        print('Modificar rutina actual');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendario",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        // Menú desplegable en la parte superior derecha del AppBar.
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white), // Ícono del menú.
            onSelected: _handleMenuOption, // Acción al seleccionar una opción.
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value:
                    'Generar rutina automática', // Identificador de la opción.
                child: Text('Generar rutina automática'), // Texto mostrado.
              ),
              PopupMenuItem(
                value: 'Crear nueva rutina', // Identificador de la opción.
                child: Text('Crear nueva rutina'), // Texto mostrado.
              ),
              PopupMenuItem(
                value: 'Modificar rutina actual', // Identificador de la opción.
                child: Text('Modificar rutina actual'), // Texto mostrado.
              ),
            ],
          ),
        ],
      ),
      body: Container(
          color: Colors.black,
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(
              2020,
              1,
              1,
            ),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (focusedDay) {
              _focusedDay = focusedDay as DateTime;
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white),
              //weekendTextStyle: TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle:
                DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white38)),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              decoration:
                  BoxDecoration(color: Colors.black), // Fondo del header
            ),
          )),
    );
  }
}
