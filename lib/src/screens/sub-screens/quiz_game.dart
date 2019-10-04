import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/screens/sub-screens/ma_quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class QuizGame extends StatefulWidget {
  final Query ref;
  final int type;
  final Bloc bloc;
  const QuizGame({this.ref, this.type, this.bloc, Key key}) : super(key: key);

  @override
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame>
    with AutomaticKeepAliveClientMixin<QuizGame> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        color: Colors.grey[200],
        child: Center(
          child: RaisedButton(
            child: Text("Play"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaQuizGame()),
              );
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
