import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/moduels/movie.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<Movie> _listMovie = [];
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    getData();
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
            )
          ],
        ),
        body: isGrid
            ? GridView.builder(
                itemCount: _listMovie.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    child: new GridTile(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_listMovie[index].image))),
                      ),
                      footer: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            _listMovie[index].name.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
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
              ));
  }

  void getData() async {
    print("start Get Data ");
    var req = await http.get("http://api.tvmaze.com/shows/1/episodes");
    List res = jsonDecode(req.body);
    List<Movie> temp = [];
    for (int i = 0; i < res.length; i++) {
      temp.add(Movie(
          id: res[i]['id'],
          url: res[i]['url'],
          image: res[i]['image']['medium'],
          name: res[i]['name'],
          summary: res[i]['summary'],
          airdate: res[i]['airdate']));
    }
    setState(() {
      _listMovie = temp;
      temp = null;
    });
  }

  void startSwitch() {
    setState(() {
      isGrid = !isGrid ;
    });
  }
}
