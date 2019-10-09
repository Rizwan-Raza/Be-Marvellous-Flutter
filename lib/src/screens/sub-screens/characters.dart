import 'package:flutter/material.dart';
import '../../blocs/bloc.dart';
import 'all_characters.dart';

class CharactersScreen extends StatelessWidget {
  final Bloc bloc;
  final int type;
  CharactersScreen({this.bloc, this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          tabs(),
          Container(
            height: MediaQuery.of(context).size.height - 190,
            child: TabBarView(
              children: <Widget>[
                AllCharacters(
                    ref: bloc.getCharacters().orderByChild("id"),
                    type: 1,
                    bloc: bloc),
                AllCharacters(
                    ref: bloc.getCharacters().orderByChild("type").equalTo("1"),
                    type: 2,
                    bloc: bloc),
                AllCharacters(
                    ref: bloc.getCharacters().orderByChild("type").equalTo("2"),
                    type: 3,
                    bloc: bloc),
              ],
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
          Tab(child: Text("All")),
          Tab(child: Text("Heroes")),
          Tab(child: Text("Villains")),
        ],
      ),
    );
  }
}
