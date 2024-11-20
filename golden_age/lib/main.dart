import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:golden_age/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golden_age/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        //para la integracion del alendario{
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // Agregado
        ],
        supportedLocales: const [
          Locale('es'), // Español genérico
          Locale('es', 'CO'), // Español de Colombia
          Locale('en'), // Inglés genérico
        ],
        //}
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage());
  }
}
