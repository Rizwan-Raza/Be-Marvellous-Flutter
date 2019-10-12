import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/screens/sub-screens/whos_who.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GuessGame extends StatefulWidget {
  final Query ref;
  final int type;
  final Bloc bloc;
  const GuessGame({this.ref, this.type, this.bloc, Key key}) : super(key: key);

  @override
  _GuessGameState createState() => _GuessGameState();
}

class _GuessGameState extends State<GuessGame>
    with AutomaticKeepAliveClientMixin<GuessGame> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: Center(
      child: RaisedButton(
        child: Text("Play"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WhosWhoGame()),
          );
        },
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
