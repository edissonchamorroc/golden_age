import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _ispasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pesa.png"),
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
                  onPressed: () {},
                  child: const Text("Iniciar sesion"),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                // TextButton(
                //   style: TextButton.styleFrom(
                //     textStyle: const TextStyle(
                //         fontSize: 16, fontStyle: FontStyle.italic),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const RegisterPage(),
                //       ),
                //     );
                //   },
                //   child: const Text("Registrarse"),
                // ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
