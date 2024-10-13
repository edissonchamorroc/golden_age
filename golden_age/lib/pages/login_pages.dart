import 'package:flutter/material.dart';
import 'package:golden_age/pages/register_page.dart';
import 'package:golden_age/pages/splash_page.dart';
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
    final result = await _firebaseApi.signInUser(_email.text, _password.text);

    if (result == 'invalid-email') {
      _showMessage('El correo electrónico está mal escrito');
    } else if (result == 'network-request-failed') {
      _showMessage('Revise su conexión a internet');
    } else if (result == 'invalid-credential') {
      _showMessage('Correo electronico o contrasena incorrecta');
    } else {
      _showMessage('Bienvenido');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SplashPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pesas.png"),
          fit: BoxFit.cover, // Ajusta la imagen para que cubra toda la pantalla
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage('assets/images/logo.png'),
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
                ElevatedButton(
                  onPressed: () {
                    _onLoginButtonClicked();
                  },
                  child: const Text("Iniciar sesion"),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      foregroundColor: Colors.white),
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
