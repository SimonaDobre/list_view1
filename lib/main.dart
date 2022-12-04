import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
          // primarySwatch: Colors.blue,
          ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  List<String> titlesList = <String>[];
  List<String> imagesList = <String>[];
  List<List<String>> genresList = <List<String>>[];

  @override
  void initState() {

    super.initState();
    getMovies();
  }

  void getMovies() {
    http.get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;
      final Map<String, dynamic> firstLevelAnswer = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = firstLevelAnswer['data'] as Map<String, dynamic>;

      final List<dynamic> listaMovies = data['movies'] as List<dynamic>;

      //titlesList.addAll(listaMovies.map((currentItem) => currentItem['title'] as String));

      for (final dynamic currentItem in listaMovies) {
        // ignore: avoid_dynamic_calls
        titlesList.add(currentItem['title'] as String);
        // ignore: avoid_dynamic_calls
        imagesList.add(currentItem['medium_cover_image'] as String);
        // ignore: avoid_dynamic_calls
        genresList.add(List<String>.from(currentItem['genres'] as List<dynamic>));
      }

      //List<Map<dynamic, dynamic>> moviesList = List<Map<dynamic, dynamic>>.from(data['movies'] as List<dynamic>);
      // for (int i = 0; i < moviesList.length; i++) {
      //   final Map<dynamic, dynamic> currentMovie = moviesList[i];
      //   String currentTitle = currentMovie['title'] as String;
      //   titlesList.add(currentTitle);
      // }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: titlesList.length,
            itemBuilder: (BuildContext context, int index) {
              final String currentTitle = titlesList[index];
              final String currentImage = imagesList[index];
              final List<String> currentGenre = genresList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(image: NetworkImage(currentImage), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 100,
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    currentTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  //Padding(
                                  //padding: const EdgeInsets.all(4),
                                  //child:
                                  Text(currentGenre[0]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
