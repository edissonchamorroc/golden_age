import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class RutinaPage extends StatefulWidget {
  const RutinaPage({super.key});

  @override
  State<RutinaPage> createState() => _RutinaPageState();
}

class _RutinaPageState extends State<RutinaPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendario",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
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
