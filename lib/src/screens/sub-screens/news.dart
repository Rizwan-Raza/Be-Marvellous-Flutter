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
  int type;
  bool checkShow = true;

  bool reverse = false;

  _OrderScreenState() {
    init();
  }

  void init() async {
    super.initState();
    this.prefs = await SharedPreferences.getInstance();
    this.watched = json.decode(prefs.getString('watchList') ?? '[]');
    this.bloc = widget.bloc;
    this.ref = bloc.getWatchList();
    this.type = widget.type;
    // print('Pressed $watched times.');
  }

  @override
  Widget build(BuildContext context) {
    type = widget.type;
    print("Method Run, News List");
    return Column(
      children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.putWatchOrder();
            },
            child: FirebaseAnimatedList(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              query: ref ??
                  ((bloc == null)
                      ? widget.bloc.getWatchList()
                      : bloc.getWatchList()),
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int x) {
                bool skipThis = false;
                WatchItem currentItem = WatchItem.fromMap(snapshot.value);
                if (!checkShow && watched.contains(currentItem.id)) {
                  skipThis = true;
                }
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
                List<Widget> list = <Widget>[];
                if (x == 0) {
                  list.add(getFilterHead());
                  list.add(showChecked());
                }
                if (!skipThis) {
                  list.add(getWatchItemTile(currentItem));
                }
                return Column(
                  children: list,
                );
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
        Divider(
          height: 0,
        ),
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
      ],
    );
  }

  Widget getFilterHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RawMaterialButton(
            textStyle: TextStyle(
              fontFamily: "Product-Sans",
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                reverse = !reverse;
              });
            },
            child: Row(
              children: <Widget>[
                Text("Released "),
                Icon(
                  reverse ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            print("Hello");
          },
          icon: Icon(
            Icons.tune,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget showChecked() {
    return SwitchListTile(
      title: const Text('Show Checked Items'),
      dense: true,
      value: checkShow,
      onChanged: (bool value) {
        setState(() {
          checkShow = !checkShow;
        });
      },
    );
  }
}
