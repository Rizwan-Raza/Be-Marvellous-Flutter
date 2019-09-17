import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/blocs/bloc_provider.dart';
import 'package:be_marvellous/src/models/character.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of(context);
    DatabaseReference ref = bloc.getCharacters();
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> map = snapshot.data.snapshot.value;
            print(map);
            return RefreshIndicator(
              onRefresh: () async {
                return await bloc.putCharacters();
              },
              child: GridView.builder(
                itemCount: map.length,
                padding: EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, int index) {
                  print(index);
                  return getCharacterTile(Character.fromMap(map[index]));
                },
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  GridTile getCharacterTile(Character char) {
    return GridTile(
      child: Container(
        child: Column(
          children: <Widget>[
            Text(char.title),
          ],
        ),
      ),
    );
  }
}
