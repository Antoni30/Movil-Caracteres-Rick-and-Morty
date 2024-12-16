import 'package:flutter/material.dart';
import 'package:api_rick_morty/controller/personajesController.dart';
import 'package:api_rick_morty/model/personajesModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterService _characterService = CharacterService();
  late Map<String, List<Character>> _categorizedCharacters;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  /// Carga inicial desde la API y luego utiliza la lista local
  void _loadCharacters() {
    _characterService.fetchCharacters().then((_) {
      setState(() {
        _categorizedCharacters = _characterService.getCategorizedCharacters(); // Obtener los personajes categorizados
      });
    }).catchError((error) {
      // Manejo de errores si la carga falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading characters: $error')),
      );
    });
  }

  /// Función para eliminar un personaje de la lista local
  void _deleteCharacter(int id) {
    setState(() {
      _characterService.deleteCharacter(id);
      _categorizedCharacters = _characterService.getCategorizedCharacters(); // Actualizar los datos categorizados después de eliminar
    });
  }

  /// Función para editar el nombre de un personaje
  void _editCharacter(int id, String newName) {
    setState(() {
      _characterService.updateCharacter(id, newName);
      _categorizedCharacters = _characterService.getCategorizedCharacters(); // Actualizar los datos categorizados después de editar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rick and Morty Characters"),
        backgroundColor: Colors.green.shade900,
      ),
      body: ListView(
        children: [
          _buildCategorySection("Alive", _categorizedCharacters['Alive']!),
          _buildCategorySection("Dead", _categorizedCharacters['Dead']!),
          _buildCategorySection("Unknown", _categorizedCharacters['Unknown']!),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Character> characters) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 250, // Altura para el scroll horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return CharacterCard(
                  character: character,
                  onDelete: () => _deleteCharacter(character.id),
                  onEdit: () {
                    _showEditDialog(character);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Character character) {
    TextEditingController nameController = TextEditingController(text: character.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Character'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Character Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _editCharacter(character.id, nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CharacterCard({
    Key? key,
    required this.character,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Ancho de cada tarjeta en scroll horizontal
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                character.image,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                character.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
