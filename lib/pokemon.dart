import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// A function that converts a response body into a List<Pokemon>.
List<Pokemon> parsePokemon(String responseBody) {
  final parsed = jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();

  return parsed.map<Pokemon>((json) => Pokemon.fromJson(json)).toList();
}

Future<List<Pokemon>> fetchPokemon(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

  // Use the compute function to run parsePokemon in a separate isolate.
  return compute(parsePokemon, response.body);
}

class Pokemon {
  final String name;
  final String url;

  const Pokemon({
    required this.name,
    required this.url,
  });


  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}