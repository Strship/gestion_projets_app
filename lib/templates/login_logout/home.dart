import 'package:flutter/material.dart';
import 'package:gestion_projets_app/templates/login_logout/projet.dart';
import 'package:gestion_projets_app/templates/pages/formprojet.dart';
import 'package:gestion_projets_app/templates/pages/parametres.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: (const Text(
            "Gestion de projets",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          )),
        ),
        body: const [
          ProojetsListPage(),
          Formprojet(),
          Parametres()
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setCurrentIndex(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Acceuil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart), label: 'Ajouter un projet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Parametre')
          ],
        ),
      ),
    );
  }
}
