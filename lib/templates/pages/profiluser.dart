import 'package:flutter/material.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({super.key});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _projectNameController,
            decoration: const InputDecoration(
              labelText: 'Nom du projet',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom de projet';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _projectDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Description du projet',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle form submission here
                final projectName = _projectNameController.text;
                final projectDescription = _projectDescriptionController.text;
                print(
                    'Created project: $projectName, Description: $projectDescription');

                // You can also navigate to a new screen here
                // Navigator.pushNamed(context, '/project-details', arguments: {
                //   'projectName': projectName,
                //   'projectDescription': projectDescription,
                // });
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
