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
                    ref: bloc.getCharacters().orderByKey(),
                    type: 1,
                    bloc: bloc),
                AllCharacters(
                    ref: bloc.getHeroes().orderByChild("type").equalTo("1"),
                    type: 2,
                    bloc: bloc),
                AllCharacters(
                    ref: bloc.getVillain().orderByChild("type").equalTo("2"),
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
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.red,
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
