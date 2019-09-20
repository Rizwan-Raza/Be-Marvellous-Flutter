import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/movies.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MediaScreen extends StatelessWidget {
  final Bloc bloc;
  final int type;
  const MediaScreen({this.bloc, this.type});

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref;
    switch (type) {
      case 2:
        ref = bloc.getTvs();
        break;
      case 1:
      default:
        ref = bloc.getMovies();
    }
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> map = snapshot.data.snapshot.value;
            return RefreshIndicator(
              onRefresh: () async {
                switch (type) {
                  case 2:
                    return await bloc.putTvs();
                  case 1:
                  default:
                    return await bloc.putMovies();
                }
              },
              child: GridView.builder(
                itemCount: map.length,
                reverse: false,
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
            placeholder: (context, url) => Image.asset("assets/img/nothing.jpg"),
            errorWidget: (context, url, error) =>
                Image.asset("assets/img/back.png"),
          ),
        ],
      ),
    );
  }
}
