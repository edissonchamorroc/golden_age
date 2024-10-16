import 'package:flutter/material.dart';
import 'package:golden_age/models/user.dart';
import 'package:golden_age/pages/login_pages.dart';
import 'package:golden_age/repository/firebase_api.dart';

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
      //_createUserInDB(user);
    }
  }

  void _onRegisterButtonClicked() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMessage("ERROR: Debe digitar correo electrónico y contraseña");
    } else if (_password.text != _repPassword.text) {
      _showMessage("ERROR: Las contraseñas deben de ser iguales");
    } else {
      String genre = _genre == Genre.male ? "Masculino" : "Femenino";
      var user = User(
        "",
        _name.text,
        _email.text,
        _password.text,
        genre,
        _expertise,
        _target,
      );
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
                color: Color.fromARGB(255, 224, 210, 210),
                fontSize: 38.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor:
                Colors.transparent, // Fondo transparente para ver la imagen
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/pesa.png'), // Tu imagen de fondo
                  fit: BoxFit
                      .cover, // Ajusta la imagen para cubrir todo el AppBar
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/olimpiashadow.png"),
              fit: BoxFit
                  .cover, // Ajusta la imagen para que cubra toda la pantalla
            ),
          ),
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
                        prefixIcon: Icon(Icons.person),
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
                        helperText: "*Campo obligatorio",
                        prefixIcon: Icon(Icons.email),
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
                        helperText: "*Campo obligatorio",
                        prefixIcon: const Icon(Icons.lock),
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
                        helperText: "*Campo obligatorio",
                        prefixIcon: const Icon(Icons.lock),
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
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    DropdownMenu<String>(
                      width: 380,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      label: const Text('Objetivo'),
                      onSelected: (String? target) {
                        setState(() {
                          _target.text = target!;
                        });
                      },
                      dropdownMenuEntries: _targets
                          .map<DropdownMenuEntry<String>>((String target) {
                        return DropdownMenuEntry<String>(
                            value: target, label: target);
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
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Registrarse"),
                    ),
                  
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
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
