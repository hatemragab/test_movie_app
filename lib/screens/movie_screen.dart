import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:movie_app/moduels/movie.dart';

import '../data/load_episodes.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key, this.loadMovies = loadEpisodes});

  final Future<List<Movie>> Function() loadMovies;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<Movie> _listMovie = [];
  bool isGrid = true;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(getData());
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Data"),
        actions: [
          IconButton(
            onPressed: () {
              startSwitch();
            },
            icon: Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : isGrid
          ? GridView.builder(
              itemCount: _listMovie.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        image: _listMovie[index].image.isEmpty
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_listMovie[index].image),
                              ),
                      ),
                      child: _listMovie[index].image.isEmpty
                          ? const Icon(Icons.movie_outlined)
                          : null,
                    ),
                    footer: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _listMovie[index].name.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ), //just for testing, will fill with image later
                );
              },
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _listMovie.length,
              itemBuilder: (context, index) {
                return Text(_listMovie[index].name.toString());
              },
            ),
    );
  }

  Future<void> getData() async {
    try {
      final movies = await widget.loadMovies();
      if (!mounted) return;
      setState(() {
        _listMovie = movies;
        _loading = false;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load episodes. Please try again later.';
        _loading = false;
      });
    }
  }

  void startSwitch() {
    setState(() {
      isGrid = !isGrid;
    });
  }
}
