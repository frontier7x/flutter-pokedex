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
    const appTitle = 'Pokemon Shiny Viewer';

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
        backgroundColor: Colors.red,
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
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: pokemon.length,
      itemBuilder: (context, index) {
        return IconButton(
          iconSize: 50,
          icon: Hero(
            tag: "poke" + (index + 1).toString(),
            child: Image.network(
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/" +
                    (index + 1).toString() +
                    ".png"),
          ),
          hoverColor: Colors.amberAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PokemonView(pokemonId: (index + 1).toString())));
          },
          //
        );
      },
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
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: FutureBuilder<PokemonData>(
          future: fetchPokemonDataView(http.Client(), pokemonId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return Column(children: [
                Hero(
                  tag: "poke" + pokemonId,
                  child: Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/" +
                        pokemonId +
                        ".png",
                  ),
                ),
                const Text(
                  'SPRITES',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' +
                          (pokemonId) +
                          '.png',
                    ),
                    Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/' +
                          (pokemonId) +
                          '.png',
                    ),
                  ],
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          snapshot.data!.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Peso: " + snapshot.data!.weight.toString() + "gr",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        "Altura: " + snapshot.data!.height.toString() + "cm",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
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
