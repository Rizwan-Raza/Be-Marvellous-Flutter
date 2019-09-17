import 'dart:convert';

import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/blocs/bloc_provider.dart';

import '../../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  SharedPreferences prefs;
  List<dynamic> watched = [];

  _OrderScreenState() {
    init();
  }

  void init() async {
    super.initState();
    prefs = await SharedPreferences.getInstance();
    watched = json.decode(prefs.getString('watchList') ?? '[]');
    // print('Pressed $watched times.');
  }

  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of(context);
    DatabaseReference ref = bloc.getWatchOrder();
    return Column(
      children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.putWatchOrder();
            },
            child: FirebaseAnimatedList(
              query: ref,
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int x) {
                return getWatchItemTile(WatchItem.fromMap(snapshot.value));
              },
              defaultChild: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }

  Widget getWatchItemTile(WatchItem item) {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          isThreeLine: true,
          title: Text("${item.id + 1}: " + item.title),
          subtitle: Text((item.type == "tv" ? item.subtitle : item.getType()) +
              "\n" +
              (item.type == "movie"
                  ? item.desc.elementAt(1)
                  : item.desc.length > 0 ? item.desc.first ?? "" : "")),
          // secondary: Icon(Icons.stars),
          secondary: Image.network(item.banner),
          onChanged: (bool value) async {
            setState(() {
              if (value) {
                watched.add(item.id);
                print(watched.toList());
              } else {
                watched.remove(item.id);
              }
            });
            await prefs.setString('watchList', json.encode(watched));
          },
          value: watched.contains(item.id),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
