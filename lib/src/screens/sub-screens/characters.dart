import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CharactersScreen extends StatelessWidget {
  final Bloc bloc;
  final int type;
  CharactersScreen({this.bloc, this.type});

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref;
    switch (type) {
      case 2:
        ref = bloc.getHeroes();
        break;
      case 3:
        ref = bloc.getVillain();
        break;
      case 1:
      default:
        ref = bloc.getCharacters();
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
                  return await bloc.putHeroes();
                case 3:
                  return await bloc.putVillain();
                case 1:
                default:
                  return await bloc.putCharacters();
              }
            },
            child: GridView.builder(
              itemCount: map.length,
              reverse: false,
              itemBuilder: (context, int index) {
                return getCharacterTile(context, Character.fromMap(map[index]));
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
      },
    );
  }

  GridTile getCharacterTile(BuildContext context, Character char) {
    return GridTile(
      footer: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        color: Color.fromRGBO(0, 0, 0, 0.66),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${char.title}",
              maxLines: 2,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Text("${char.subtitle}",
                maxLines: 2, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
      child: CachedNetworkImage(
        height: 300.0,
        width: MediaQuery.of(context).size.width / 3,
        fit: BoxFit.cover,
        imageUrl: "https://terrigen-cdn-dev.marvel.com/content/prod/1x/" +
            (char.image ?? "default/explore-no-img.jpg"),
        placeholder: (context, url) => Image.asset("assets/img/nothing.jpg"),
        errorWidget: (context, url, error) => Image.asset("assets/img/back.png"),
      ),
      // Positioned(
      //   bottom: 0.0,
      //   width: MediaQuery.of(context).size.width / 3,
      //   child: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //     color: Color.fromRGBO(0, 0, 0, 0.5),
      //     child: Text(
      //       "${char.title}",
      //       maxLines: 2,
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ),
    );
  }
}
