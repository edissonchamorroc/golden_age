import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golden_age/models/Exercise.dart';
import 'package:golden_age/models/golden_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  Future<String?> createUser(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print('Firebase auth exception ${e.code}');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', credential.user!.uid);
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future<void> singOutUser() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<String> insertUser(GoldenUser newUser) async {
    try {
      var db = FirebaseFirestore.instance;
      await db.collection('users').doc(newUser.uid).set(newUser.toMap());
      return newUser.uid;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

  Future<GoldenUser?> getUserByUid(String? uid) async {
    try {
      var db = FirebaseFirestore
          .instance; // Obtén el documento del usuario por su UID
      var docSnapshot = await db.collection('users').doc(uid).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return GoldenUser.fromMap(docSnapshot.data()!);
      } else {
        print("No se encontró el usuario con UID: $uid");
        return null;
      }
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return null;
    } catch (e) {
      print("Error al obtener el usuario: $e");
      return null;
    }
  }

  Future<List<Exercise>?> fetchExercises(String muscleGroup) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    try {
      var firestore = FirebaseFirestore.instance;

      // Obtiene la información del usuario
      var docSnapshot = await firestore.collection('users').doc(userId).get();
      GoldenUser? user = GoldenUser.fromMap(docSnapshot.data()!);

      // Realiza la consulta para obtener los ejercicios
      final querySnapshot = await firestore.collection('exercises').get();

      // Extrae los datos de los documentos y desanida los mapas
      List<Map<String, dynamic>> exercisesData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .expand((exerciseMap) => exerciseMap.values) // Desanida los valores
          .map((value) =>
              value as Map<String, dynamic>) // Convierte cada valor en un mapa
          .toList();

      // Convierte los datos en objetos Exercise y filtra por nivel y grupo muscular
      List<Exercise> filteredExercises = exercisesData
          .map((exerciseData) => Exercise.fromJson(exerciseData))
          .where((exercise) =>
              exercise.nivel == user.expertise &&
              exercise.muscleGroup == muscleGroup)
          .toList();

      return filteredExercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }
}
