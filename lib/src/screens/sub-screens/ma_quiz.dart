import 'package:flutter/material.dart';

class MaQuizGame extends StatefulWidget {
  MaQuizGame({Key key}) : super(key: key);

  _MaQuizGameState createState() => _MaQuizGameState();
}

class _MaQuizGameState extends State<MaQuizGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MaQuiz: Marvel Quiz"),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.red[200],
              height: MediaQuery.of(context).size.height / 2 - 50,
              child: Center(
                child: Text(
                  "Question goes here, Which can be two to three lines, don't know?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    getTile("Hello World"),
                    getTile("Hello World"),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                Row(
                  children: <Widget>[
                    getTile("Hello World"),
                    getTile("Hello World"),
                  ],
                ),
              ],
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
        height: 100.0,
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
