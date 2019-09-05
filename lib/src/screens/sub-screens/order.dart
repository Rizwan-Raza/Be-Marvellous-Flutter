import 'dart:convert';

import 'package:be_marvellous/src/models/watch_item.dart';
import 'package:be_marvellous/src/models/watch_items.dart';
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
    print('Pressed $watched times.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.reference().child("order"),
            padding: EdgeInsets.all(8.0),
            reverse: false,
            itemBuilder:
                (_, DataSnapshot snapshot, Animation<double> animation, int x) {
              return getWatchItemTile(
                  WatchItem.fromMap(snapshot.value, int.parse(snapshot.key)));
            },
          ),
        ),
      ],
    );
  }

  Widget getWatchItemTile(WatchItem item) {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text(item.title),
          subtitle: Text(WatchItems.getTitle(item.type)),
          dense: true,
          secondary: Icon(Icons.stars),
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
