import 'package:be_marvellous/src/screens/sub-screens/guess_game.dart';
import 'package:be_marvellous/src/screens/sub-screens/quiz_game.dart';
import 'package:flutter/material.dart';
import '../../blocs/bloc.dart';

class GamesScreen extends StatelessWidget {
  final Bloc bloc;
  final int type;
  GamesScreen({this.bloc, this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          tabs(),
          Divider(height: 0),
          Container(
            height: MediaQuery.of(context).size.height - 190,
            child: TabBarView(
              children: <Widget>[GuessGame(), QuizGame()],
            ),
          )
        ],
      ),
    );
  }

  Widget tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.red,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.black87,
        tabs: <Widget>[
          Tab(child: Text("Who's Who")),
          Tab(child: Text("MaQuiz")),
        ],
      ),
    );
  }
}
