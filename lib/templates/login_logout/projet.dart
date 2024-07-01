import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class ProojetsListPage extends StatefulWidget {
  const ProojetsListPage({super.key});

  @override
  State<ProojetsListPage> createState() => _ProojetsListPageState();
}

class _ProojetsListPageState extends State<ProojetsListPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "Tous";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              'Listes des Projets',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightBlue),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 25),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: <String>['Tous', 'En attente', 'En cours', 'Terminé']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Projets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Affiche les données récupérées depuis Firestore
          //final projets = snapshot.data!.docs; (Si je ne veux pas utiliser la recherche)

          /*   final projets = snapshot.data!.docs.where((doc) {
            final nomProjet = doc['nom_projet'] as String;
            return nomProjet.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList(); */

          // Filtrer les projets en fonction de la requête de recherche et du filtre sélectionné
          final projets = snapshot.data!.docs.where((doc) {
            final nomProjet = doc['nom_projet'] as String;
            final statut = doc['statut'] as String;
            final matchesSearchQuery =
                nomProjet.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesFilter =
                _selectedFilter == "Tous" || statut == _selectedFilter;
            return matchesSearchQuery && matchesFilter;
          }).toList();

          return ListView.builder(
            itemCount: projets.length,
            itemBuilder: (context, index) {
              final projet = projets[index];
              final nomProjet = projet['nom_projet'];
              final descProjet = projet['desc_projet'];
              final dateDebut = (projet['date_bebut'] as Timestamp).toDate();
              final dateFin = (projet['date_fin'] as Timestamp).toDate();
              final statut = projet['statut'];

              return ListTile(
                title: Text(nomProjet),
                subtitle: Text(
                    'Description: $descProjet\nDébut: $dateDebut\nFin: $dateFin\nStatut: $statut'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Action de modification
                        _editProject(context, projet.id, nomProjet, descProjet,
                            dateDebut, dateFin, statut);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Fonction pour la suppression
                        _showDeleteConfirmationDialog(context, projet.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce projet ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('Projets').doc(id).delete();
              Navigator.of(context).pop();
            },
            child: const Text('Supprimer (Oui)'),
          ),
        ],
      );
    },
  );
}

void _editProject(BuildContext context, String id, String nomProjet,
    String descProjet, DateTime dateDebut, DateTime dateFin, String statut) {
  final nomController = TextEditingController(text: nomProjet);
  final descController = TextEditingController(text: descProjet);
  DateTime? newDateDebut = dateDebut;
  DateTime? newDateFin = dateFin;
  String selectedStatut = statut;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Modifier le Projet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom du projet'),
              ),
              TextField(
                controller: descController,
                decoration:
                    const InputDecoration(labelText: 'Description du projet'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DateTimeFormField(
                  initialValue: dateDebut,
                  decoration: const InputDecoration(
                    labelText: 'Date de début',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  onChanged: (DateTime? value) {
                    newDateDebut = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DateTimeFormField(
                  initialValue: dateFin,
                  decoration: const InputDecoration(
                    labelText: 'Date de fin',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  onChanged: (DateTime? value) {
                    newDateFin = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                        value: 'statut',
                        child: Text('Quel est le statut de votre projet')),
                    DropdownMenuItem(
                        value: 'En attente', child: Text('En attente')),
                    DropdownMenuItem(
                        value: 'En cours', child: Text('En cours')),
                    DropdownMenuItem(value: 'Terminé', child: Text('Terminé')),
                  ],
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  value: selectedStatut,
                  onChanged: (value) {
                    selectedStatut = value!;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('Projets').doc(id).update({
                'nom_projet': nomController.text,
                'desc_projet': descController.text,
                'date_debut': newDateDebut,
                'date_fin': newDateFin,
                'statut': selectedStatut,
              });
              Navigator.of(context).pop();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      );
    },
  );
}
