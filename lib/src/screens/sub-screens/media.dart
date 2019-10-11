import 'package:be_marvellous/src/screens/sub-screens/movie.dart';
import 'package:be_marvellous/src/screens/sub-screens/news.dart';
import 'package:be_marvellous/src/screens/sub-screens/wallpapers.dart';
import 'package:flutter/material.dart';
import '../../blocs/bloc.dart';

class MediaScreen extends StatelessWidget {
  final Bloc bloc;
  final int type;
  MediaScreen({this.bloc, this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          tabs(),
          Container(
            height: MediaQuery.of(context).size.height - 190,
            child: TabBarView(
              children: <Widget>[
                NewsScreen(bloc: bloc),
                Movies(ref: bloc.getMovies().orderByKey(), type: 1, bloc: bloc),
                Movies(ref: bloc.getTvs(), type: 2, bloc: bloc),
                Wallpapers(ref: bloc.getWallpapers(), bloc: bloc),
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
          Tab(child: Text("News")),
          Tab(child: Text("Movies")),
          Tab(child: Text("TV Shows")),
          Tab(child: Text("Wallpapers")),
        ],
      ),
    );
  }
}
