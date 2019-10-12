import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/movies.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Movies extends StatefulWidget {
  final Query ref;
  final int type;
  final Bloc bloc;
  const Movies({this.ref, this.type, this.bloc, Key key}) : super(key: key);

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies>
    with AutomaticKeepAliveClientMixin<Movies> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: widget.ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> map = snapshot.data.snapshot.value.values.toList();
            map.sort((a, b) =>
                "${a['date']['year']}${a['date']['month'].padLeft(2, "0")}${a['date']['day'].padLeft(2, "0")}"
                    .compareTo(
                        "${b['date']['year']}${b['date']['month'].padLeft(2, "0")}${b['date']['day'].padLeft(2, "0")}"));
            return RefreshIndicator(
              onRefresh: () async {
                switch (widget.type) {
                  case 2:
                    return await widget.bloc.putTvs();
                  case 1:
                  default:
                    return await widget.bloc.putMovies();
                }
              },
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: map.length,
                itemBuilder: (context, int index) {
                  return getMovieTile(context, Movie.fromMap(map[index]));
                },
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2 / 3),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  GridTile getMovieTile(BuildContext context, Movie movie) {
    return GridTile(
      footer: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color: Color.fromRGBO(0, 0, 0, 0.66),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${movie.title}",
              maxLines: 2,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Text("${movie.subtitle}",
                maxLines: 2, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            height: 300.0,
            width: MediaQuery.of(context).size.width / 3,
            fit: BoxFit.cover,
            imageUrl: "https://terrigen-cdn-dev.marvel.com/content/prod/1x/" +
                (movie.image ?? "default/explore-no-img.jpg"),
            placeholder: (context, url) =>
                Image.asset("assets/img/nothing.jpg"),
            errorWidget: (context, url, error) =>
                Image.asset("assets/img/back.png"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
