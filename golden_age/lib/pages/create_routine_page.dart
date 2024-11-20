import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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

  //funcion para mostrar el calendario
  void _showSelectedDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      locale: const Locale("es", "CO "),
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      helpText: "Fecha de Inicio",
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                Colors.black, // Color principal (barra superior y selección)
            colorScheme: ColorScheme.light(
              primary: Colors.grey, // Color de los elementos seleccionados
              onPrimary: Colors.white, // Color del texto en la barra superior
              onSurface: Colors.black, // Color del texto de las fechas
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors
                    .black, // Color de los botones de acción (Aceptar/Cancelar)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      setState(() {
        _data = newDate;
        buttonMsg = "Fecha de Inicio ${_dateConverter((_data))}";
      });
    }
  }

  final _bloquesProgramados = TextEditingController();
  final _numeroDeDiasPorBloque = TextEditingController();

  bool _lunes = false;
  bool _martes = false;
  bool _miercoles = false;
  bool _jueves = false;
  bool _viernes = false;
  bool _sabado = false;
  bool _domingo = false;

  String buttonMsg = "Fecha de inicial";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nueva rutina",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _numeroDeDiasPorBloque,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "Dias por bloque",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0), // Borde cuando no está enfocado
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Borde cuando está enfocado
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _bloquesProgramados,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "Numero de bloques programados",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0), // Borde cuando no está enfocado
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Borde cuando está enfocado
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                    title: const Text("Lunes"),
                    value: _lunes, //para extraer la información
                    selected: _lunes, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _lunes =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Martes"),
                    value: _martes, //para extraer la información
                    selected: _martes, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _martes =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Miercoles"),
                    value: _miercoles, //para extraer la información
                    selected: _miercoles, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _miercoles =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Jueves"),
                    value: _jueves, //para extraer la información
                    selected: _jueves, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _jueves =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Viernes"),
                    value: _viernes, //para extraer la información
                    selected: _viernes, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _viernes =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Sabado"),
                    value: _sabado, //para extraer la información
                    selected: _sabado, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _sabado =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                CheckboxListTile(
                    title: const Text("Domingo"),
                    value: _domingo, //para extraer la información
                    selected: _domingo, //Para cambiar el estado
                    activeColor:
                        Colors.black, // Color del checkbox cuando está marcado.
                    onChanged: (bool? value) {
                      //cuando doy click se ejecuta el setstate
                      setState(() {
                        _domingo =
                            value!; //Cuando se presiona se cambia el estado de la variable
                      });
                    }),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: Text(buttonMsg),
                    onPressed: () {
                      _showSelectedDate();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
