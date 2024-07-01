import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projets_app/templates/login_logout/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyAR8QdAJedjgPWmmBHhZpKymOyLtP_YRCk", // paste your api key here
      appId:
          "1:596756102848:android:53d396a96c56b4f414f725", //paste your app id here
      messagingSenderId: "596756102848", //paste your messagingSenderId here
      projectId: "gestionprojetsapp", //paste your project id here
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login(),
    );
  }
}
