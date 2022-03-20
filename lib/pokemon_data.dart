import 'dart:async';
import 'dart:convert';


import 'package:http/http.dart' as http;


Future<PokemonData> fetchPokemonDataView(http.Client client, String pokemonId) async {
  final response = await client
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'+(pokemonId)));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PokemonData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pokemon');
  }
}

class PokemonData {
  final String name;
  final int? weight;
  final int? baseExperience;
  final int? height;


  const PokemonData({
    required this.name,
    required this.weight,
    required this.baseExperience,
    required this.height,
  });


  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
      name: json['name'],
      weight: json['weight']*100,
      baseExperience: json['baseExperience'],
      height: json['height']*10,
    );
  }
}