import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokeapp/pokeMon.dart';
import 'package:pokeapp/pokemon_detail.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Poke App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: PokeApp(),
    );
  }
}

//  ? This func is used for building the home page

class PokeApp extends StatefulWidget {
  const PokeApp({Key key}) : super(key: key);

  @override
  _PokeAppState createState() => _PokeAppState();
}

class _PokeAppState extends State<PokeApp> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ! here i defined fecth data
  fetchData() async {
    var res = await http.get(Uri.parse(url));
    var decodeJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodeJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyan, title: Text("Poke App")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Refresh the code",
        child: Icon(Icons.refresh),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: pokeHub.pokemon.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => DetailPage(
                                  pokemon: pokeHub.pokemon[index],
                                )));
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          width: 200,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 75,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          pokeHub.pokemon[index].name,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Color.fromRGBO(
                                                  52, 73, 94, 100),
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -50,
                          right: 0,
                          left: 0,
                          child: Hero(
                              tag: pokeHub.pokemon[index].img,
                              child: Image.network(pokeHub.pokemon[index].img)))
                    ],
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 9),
            ),
    );
  }
}
