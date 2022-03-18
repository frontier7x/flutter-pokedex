
import 'package:api_test_pokemon/pokemon.dart';
import 'package:api_test_pokemon/pokemon_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class PokemonArguments {
  final String pokemonId;

  PokemonArguments(this.pokemonId);
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Pokemon API';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),

    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: fetchPokemon(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PokemonList(pokemon: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PokemonList extends StatelessWidget {
  const PokemonList({Key? key, required this.pokemon}) : super(key: key);

  final List<Pokemon> pokemon;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: pokemon.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonView(pokemonId: (index+1).toString()))); },
            child:
            Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"+(index+1).toString()+".png"),
            //
        );},
    );
  }
}

class PokemonView extends StatelessWidget {
  const PokemonView({Key? key, required this.pokemonId}) : super(key: key);
  final String pokemonId;
  @override
  Widget build(BuildContext context) {
    //final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Pokemon'),
      ),
      body: Center(
        child: FutureBuilder<PokemonData>(
          future: fetchPokemonDataView(http.Client(), pokemonId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return  Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return GridTile(
                child: Text(snapshot.data!.name),
                header: Text(snapshot.data!.name),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

}


