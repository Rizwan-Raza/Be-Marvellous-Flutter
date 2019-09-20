import 'dart:convert';

import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  final Bloc bloc;
  final int type;
  const OrderScreen({this.bloc, this.type, Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Bloc bloc;
  DatabaseReference ref;
  SharedPreferences prefs;
  List<dynamic> watched = [];
  int type = 0;

  _OrderScreenState() {
    init();
  }

  void init() async {
    super.initState();
    this.prefs = await SharedPreferences.getInstance();
    this.watched = json.decode(prefs.getString('watchList') ?? '[]');
    this.bloc = widget.bloc;
    this.ref = bloc.getWatchOrder();
    this.type = widget.type;
    // print('Pressed $watched times.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.putWatchOrder();
            },
            child: FirebaseAnimatedList(
              query: ref ??
                  ((bloc == null)
                      ? widget.bloc.getWatchOrder()
                      : bloc.getWatchOrder()),
              reverse: false,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int x) {
                bool skipThis = false;
                WatchItem currentItem = WatchItem.fromMap(snapshot.value);
                switch (type) {
                  case 2:
                    if (currentItem.type != "movie") {
                      skipThis = true;
                    }
                    break;
                  case 3:
                    if (currentItem.type != "tv") {
                      skipThis = true;
                    }
                    break;
                  case 4:
                    if (currentItem.type != "comic" &&
                        currentItem.type != "book") {
                      skipThis = true;
                    }
                    break;
                  case 5:
                    if (currentItem.type != "movie" &&
                        currentItem.type != "tv" &&
                        currentItem.type != "short_film") {
                      skipThis = true;
                    }
                    break;
                  case 1:
                  default:
                    break;
                }
                if (skipThis) return Container();
                return getWatchItemTile(currentItem);
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
          title: Text(
              // "${item.id + 1}: " +
              item.title),
          subtitle: Text((item.type == "tv" ? item.subtitle : item.getType()) +
              "\n" +
              (item.type == "movie"
                  ? item.desc.elementAt(1)
                  : item.desc.length > 0 ? item.desc.first ?? "" : "")),
          // secondary: Icon(Icons.stars),
          secondary: CachedNetworkImage(
            imageUrl: item.banner,
            placeholder: (context, url) =>
                Image.asset("assets/img/nothing.jpg"),
            errorWidget: (context, url, error) =>
                Image.asset("assets/img/back.png"),
          ),
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
