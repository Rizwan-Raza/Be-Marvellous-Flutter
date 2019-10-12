import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WhosWhoGame extends StatefulWidget {
  WhosWhoGame({Key key}) : super(key: key);

  _WhosWhoGameState createState() => _WhosWhoGameState();
}

class _WhosWhoGameState extends State<WhosWhoGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Who's Who: Guess Game"),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.red[200],
              height: MediaQuery.of(context).size.height / 2 - 58,
              child: CachedNetworkImage(
                imageUrl:
                    "https://terrigen-cdn-dev.marvel.com/content/prod/1x/default/explore-no-img.jpg",
              ),
            ),
            Container(
              // color: Colors.red[200],
              height: MediaQuery.of(context).size.height / 2 - 58,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      getTile("Hello World"),
                      getTile("Hello World"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      getTile("Hello World"),
                      getTile("Hello World"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTile(String text) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        height: MediaQuery.of(context).size.height / 4 - 37,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
