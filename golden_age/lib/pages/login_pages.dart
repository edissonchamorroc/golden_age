import 'package:flutter/material.dart';
import 'package:golden_age/pages/register_page.dart';
import 'package:golden_age/pages/navigation_bar_page.dart';
import 'package:golden_age/repository/firebase_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _ispasswordObscure = true;
  final FirebaseApi _firebaseApi = FirebaseApi();

  void _showMessage(String msg) {
    setState(() {
      SnackBar snackBar = SnackBar(content: Text(msg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> _onLoginButtonClicked() async {
    // Validar si los campos están vacíos
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _showMessage('Por favor, ingrese su correo electrónico y contraseña');
      return;
    }
    final result = await _firebaseApi.signInUser(_email.text, _password.text);
    if (result == 'invalid-email') {
      _showMessage('El correo electrónico está mal escrito');
    } else if (result == 'network-request-failed') {
      _showMessage('Revise su conexión a internet');
    } else if (result == 'invalid-credential' || result == null) {
      _showMessage("Correo electrónico o contrasena incorrecta");
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const NavigationBarPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black, // Fondo negro sólido
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage('assets/imagenes/logo.png'),
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 80.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "Digite su correo",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.email),
                    prefixIconColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0), // Borde cuando no está enfocado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Borde cuando está enfocado
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
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0), // Borde cuando no está enfocado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0), // Borde cuando está enfocado
                    ),
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
                ElevatedButton(
                  onPressed: () {
                    _onLoginButtonClicked();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white, // Fondo blanco
                    side: const BorderSide(
                        color: Colors.grey, width: 2.0), // Borde gris
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0), // Ajuste de padding
                  ),
                  child: const Text("Iniciar sesion",
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
