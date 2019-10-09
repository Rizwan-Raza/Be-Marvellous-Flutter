import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/character.dart';
import 'package:be_marvellous/src/screens/sub-screens/character_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AllCharacters extends StatefulWidget {
  final Query ref;
  final int type;
  final Bloc bloc;
  const AllCharacters({this.ref, this.type, this.bloc, Key key})
      : super(key: key);

  @override
  _AllCharactersState createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters>
    with AutomaticKeepAliveClientMixin<AllCharacters> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: widget.ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> map = snapshot.data.snapshot.value.values.toList();
          // print(map);
          map.sort((a, b) => a['link'].compareTo(b['link']));
          return RefreshIndicator(
            onRefresh: () async {
              switch (widget.type) {
                case 2:
                  return await widget.bloc.putHeroes();
                case 3:
                  return await widget.bloc.putVillain();
                case 1:
                default:
                  return await widget.bloc.putCharacters();
              }
            },
            child: GridView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
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

  Widget getCharacterTile(BuildContext context, Character char) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CharacterDetail(bloc: widget.bloc, item: char)),
        );
      },
      child: GridTile(
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
          errorWidget: (context, url, error) =>
              Image.asset("assets/img/back.png"),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
