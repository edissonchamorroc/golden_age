import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:golden_age/pages/login_pages.dart';
import 'package:golden_age/pages/navigation_bar_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _closeSplash() async {
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NavigationBarPage()));
        }
      });
    });
  }

  @override
  void initState() {
    _closeSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/olimpiashadow.png"),
            fit: BoxFit
                .cover, // Ajusta la imagen para que cubra toda la pantalla
          ),
        ),
      ),
    );
  }
}
