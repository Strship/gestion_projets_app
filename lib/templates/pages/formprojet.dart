import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class Formprojet extends StatefulWidget {
  const Formprojet({super.key});

  @override
  State<Formprojet> createState() => _FormprojetState();
}

class _FormprojetState extends State<Formprojet> {
  final _formKey = GlobalKey<FormState>();
  final nomprojetController = TextEditingController();
  final desprojetController = TextEditingController();
  DateTime seletedProjetDebut = DateTime.now();
  DateTime seletedProjetFin = DateTime.now();
  String selectedStatut = 'statut';

  @override
  void dispose() {
    super.dispose();
    nomprojetController.dispose();
    desprojetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Formulaire d'ajout de nouveau projet",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom du projet',
                      hintText: 'Entrer le nom du projet',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez compléter ce champ";
                      }
                      return null;
                    },
                    controller: nomprojetController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description du projet',
                      hintText: 'Entrer la description du projet',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez compléter ce champ";
                      }
                      return null;
                    },
                    controller: desprojetController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Choisissez la date de début',
                    ),
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) => (e?.day ?? 0) == 1
                        ? 'Entrer la date début du projet'
                        : null,
                    onChanged: (DateTime? value) {
                      setState(() {
                        seletedProjetDebut = value!;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Choisissez la date de fin du projet',
                    ),
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Entrer la date fin' : null,
                    onChanged: (DateTime? value) {
                      setState(() {
                        seletedProjetFin = value!;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'statut',
                        child: Text('Quel est le statut de votre projet'),
                      ),
                      DropdownMenuItem(
                          value: 'En attente', child: Text('En attente')),
                      DropdownMenuItem(
                          value: 'En cours', child: Text('En cours')),
                      DropdownMenuItem(
                          value: 'Terminé', child: Text('Terminé')),
                    ],
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: selectedStatut,
                    onChanged: (value) {
                      setState(() {
                        selectedStatut = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final nomprojetName = nomprojetController.text;
                        final descprojetName = desprojetController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours")),
                        );
                        FocusScope.of(context).requestFocus(FocusNode());

                        //ajout dans la base de données
                        CollectionReference projetsRef =
                            FirebaseFirestore.instance.collection("Projets");
                        projetsRef.add({
                          'nom_projet': nomprojetName,
                          'desc_projet': descprojetName,
                          'date_debut': seletedProjetDebut,
                          'date_fin': seletedProjetFin,
                          'statut': selectedStatut,
                        });

                        print(
                          "Ajout du projet $nomprojetName dont la description est $descprojetName",
                        );
                        print("La date début $seletedProjetDebut");
                        print("La fin du projet est $seletedProjetFin");
                      }
                    },
                    child: const Text('Envoyer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
