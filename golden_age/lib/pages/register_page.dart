import 'package:flutter/material.dart';
import 'package:golden_age/models/user.dart';
import 'package:golden_age/pages/login_pages.dart';
import 'package:golden_age/repository/firebase_api.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Genre { male, female }

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repPassword = TextEditingController();
  final _expertise = TextEditingController();
  final _target = TextEditingController();
  bool _ispasswordObscure = true;
  Genre? _genre = Genre.male;
  final FirebaseApi _firebaseApi = FirebaseApi();

  final List<String> _targets = [
    'Hipertrofia',
    'Perder grasa',
    'Fuerza',
    'Resistencia',
  ];

  String buttonMsg = "Fecha de nacimiento";

  DateTime _data = DateTime.now();

  //Función para extrer la información del calendario
  String _dateConverter(DateTime newDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(newDate);
    return dateFormatted;
  }

  //funcion para mostrar el calendario
  void _showSelectedDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      locale: const Locale("es", "CO"),
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      helpText: "Fecha de Nacimiento",
    );
    if (newDate != null) {
      setState(() {
        _data = newDate;
        buttonMsg = "Fecha de nacimiento ${_dateConverter((_data))}";
      });
    }
  }

  void _showMessage(String msg) {
    setState(() {
      SnackBar snackBar = SnackBar(content: Text(msg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _createUser(User user) async {
    var result = await _firebaseApi.createUser(user.email, user.password);
    if (result == 'invalid-email') {
      _showMessage('El correo electrónico está mal escrito');
    } else if (result == 'email-already-in-use') {
      _showMessage('Ya existe una cuenta con ese correo electrónico');
    } else if (result == 'weak-password') {
      _showMessage('La contraseña debe tener mínimo 6 dígitos');
    } else if (result == 'network-request-failed') {
      _showMessage('Revise su conexión a internet');
    } else {
      user.uid = result!;
      Navigator.pop(context);
      //_createUserInDB(user);
    }
  }

  /*void _onRegisterButtonClicked() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMessage("ERROR: Debe digitar correo electrónico y contraseña");
    } else if (_password.text != _repPassword.text) {
      _showMessage("ERROR: Las contraseñas deben de ser iguales");
    } else {
      String genre = _genre == Genre.male ? "Masculino" : "Femenino";
      var user = User(
        _name.text,
        _email.text,
        _password.text,
        genre,
        _expertise.text,
        _target.text
      );
      _createUser(user);
    }
  }*/
  void _onRegisterButtonClicked() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMessage("ERROR: Debe digitar correo electrónico y la contraseña");
    } else if (_password.text != _repPassword.text) {
      _showMessage("ERROR: Las contraseñas deben ser iguales");
    } else {
      String genre = _genre == Genre.male ? "Maculino" : "Femenino";
      var user = User("", _name.text, _email.text, _password.text, genre,
          _expertise.text, _target);
      _createUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            title: const Text(
              'GOLDE AGE',
              style: TextStyle(
                //color: Color.fromARGB(255, 224, 210, 210),
                color: Colors.white,
                fontSize: 38.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black,
            //Colors.transparent, // Fondo transparente para ver la imagen
            /*/
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/pesa.png'), // Tu imagen de fondo
                  fit: BoxFit
                      .cover, // Ajusta la imagen para cubrir todo el AppBar
                ),
              ),
            ),*/
          ),
        ),
        body: Container(
          color: Colors.white,
          /*decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/olimpiashadow.png"),
              fit: BoxFit
                  .cover, // Ajusta la imagen para que cubra toda la pantalla
            ),
          ),*/
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Digite su nombre",
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
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Digite su correo",
                        labelStyle: TextStyle(color: Colors.black),
                        helperText: "*Campo obligatorio",
                        helperStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email),
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
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: _ispasswordObscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        labelText: "Digite la contrasena",
                        labelStyle: TextStyle(color: Colors.black),
                        helperText: "*Campo obligatorio",
                        helperStyle: TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: Colors.black,
                        suffixIcon: IconButton(
                          icon: Icon(_ispasswordObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _ispasswordObscure = !_ispasswordObscure;
                            });
                          },
                        ),
                        suffixIconColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                          // Borde cuando no está enfocado
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0), // Borde cuando está enfocado
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isPasswordValid()
                          ? null
                          : "La contraseña debe tener mínimo 6 caracteres",
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _repPassword,
                      obscureText: _ispasswordObscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                        labelText: "Repita la contrasena",
                        labelStyle: TextStyle(color: Colors.black),
                        helperText: "*Campo obligatorio",
                        helperStyle: TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: Colors.black,
                        suffixIcon: IconButton(
                          icon: Icon(_ispasswordObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _ispasswordObscure = !_ispasswordObscure;
                            });
                          },
                        ),
                        suffixIconColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0), // Borde cuando no está enfocado
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0), // Borde cuando está enfocado
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
/*
                    DropdownMenu<String>(
                      width: 380,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      //label: const Text('Objetivo'),
                      label: const Text(
                        'Objetivo',
                        style: TextStyle(
                          color: Colors
                              .black, // Color del texto de la etiqueta "Objetivo"
                        ),
                      ),
                      onSelected: (String? target) {
                        setState(() {
                          _target.text = target!;
                        });
                      },
                      
                      dropdownMenuEntries: _targets
                          .map<DropdownMenuEntry<String>>((String target) {
                        return DropdownMenuEntry<String>(
                            value: target, label: target);
                      }
                      
                      ).toList(),
                      
                    ),*/
                    DropdownButtonFormField<String>(
                      value: _target.text.isEmpty ? null : _target.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Colors.white, // Color de fondo del menú desplegable
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: 'Objetivo',
                        labelStyle: TextStyle(
                          color: Colors
                              .black, // Color del texto de la etiqueta "Objetivo"
                        ),
                      ),
                      dropdownColor:
                          Colors.white, // Color de fondo del menú desplegable
                      iconEnabledColor:
                          Colors.black, // Color del icono desplegable
                      style: TextStyle(
                        color: Colors.black, // Color del texto seleccionado
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _target.text = newValue!;
                        });
                      },
                      items: _targets
                          .map<DropdownMenuItem<String>>((String target) {
                        return DropdownMenuItem<String>(
                          value: target,
                          child: Text(
                            target,
                            style: TextStyle(
                              color: Colors
                                  .black, // Color del texto dentro de cada opción
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text("Seleccione su género"),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              "Masculino",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Radio<Genre>(
                              value: Genre.male,
                              groupValue: _genre,
                              activeColor: Colors
                                  .black, // Cambia el color activo a negro
                              onChanged: (Genre? value) {
                                setState(() {
                                  _genre = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text("Femenino",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            leading: Radio<Genre>(
                              value: Genre.female,
                              groupValue: _genre,
                              activeColor: Colors
                                  .black, // Cambia el color activo a negro
                              onChanged: (Genre? value) {
                                setState(() {
                                  _genre = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    //Boton para mostrar el calendario
                    ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white, // Fondo blanco
                          side: const BorderSide(
                              color: Colors.grey, width: 2.0), // Borde gris
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0), // Ajuste de padding
                        ),
                        child: Text(buttonMsg,
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          _showSelectedDate();
                        }),

                    const SizedBox(
                      height: 16,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _onRegisterButtonClicked();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, // Fondo blanco
                        side: const BorderSide(
                            color: Colors.grey, width: 2.0), // Borde gris
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0), // Ajuste de padding
                      ),
                      child: const Text("Registrarse",
                          style: TextStyle(color: Colors.black)),
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      //foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text("Regresar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

extension on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension on String {
  bool isPasswordValid() {
    return length > 5;
  }
}
