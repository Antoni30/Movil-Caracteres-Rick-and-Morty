import 'dart:convert';
import 'package:api_rick_morty/model/personajesModel.dart';
import 'package:http/http.dart' as http;

class CharacterService {
  final String apiUrl = "https://rickandmortyapi.com/api/character";
  List<Character> _allCharacters = [];

  /// Carga y organiza los personajes de la API
  Future<void> fetchCharacters() async {
    if (_allCharacters.isEmpty) {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // Convierte resultados en objetos Character
        _allCharacters = results.map((item) => Character.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    }
  }

  /// Devuelve los personajes categorizados en la lista local
  Map<String, List<Character>> getCategorizedCharacters() {
    List<Character> alive = _allCharacters
        .where((character) => character.status == 'Alive')
        .toList();
    List<Character> dead = _allCharacters
        .where((character) => character.status == 'Dead')
        .toList();
    List<Character> unknown = _allCharacters
        .where((character) => character.status == 'unknown')
        .toList();

    return {
      'Alive': alive,
      'Dead': dead,
      'Unknown': unknown,
    };
  }

  /// Actualiza un personaje en la lista local
  void updateCharacter(int id, String newName) {
    for (var character in _allCharacters) {
      if (character.id == id) {
        character.name = newName;
        break;
      }
    }
  }

  /// Elimina un personaje de la lista local
  void deleteCharacter(int id) {
    _allCharacters.removeWhere((character) => character.id == id);
  }
}
