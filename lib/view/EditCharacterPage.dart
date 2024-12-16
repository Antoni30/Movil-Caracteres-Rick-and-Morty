import 'package:flutter/material.dart';
import 'package:api_rick_morty/controller/personajesController.dart';
import 'package:api_rick_morty/model/personajesModel.dart';

class EditCharacterPage extends StatefulWidget {
  final Character character;

  const EditCharacterPage({Key? key, required this.character}) : super(key: key);

  @override
  _EditCharacterPageState createState() => _EditCharacterPageState();
}

class _EditCharacterPageState extends State<EditCharacterPage> {
  final CharacterService _characterService = CharacterService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.character.name; // Inicializa con el nombre actual
  }

  void _saveChanges() {
    // Actualiza el personaje en la lista local
    _characterService.updateCharacter(widget.character.id, _nameController.text);

    // Regresa a la vista anterior
    Navigator.pop(context);

    // Muestra un mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Character updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Character"),
        backgroundColor: Colors.green.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
