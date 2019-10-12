import 'dart:convert';

import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import '../../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  final Bloc bloc;
  const OrderScreen({this.bloc, Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Bloc bloc;
  DatabaseReference ref;
  SharedPreferences prefs;
  List<dynamic> watched = [];
  bool checkShow = true;

  bool reverse = false;

  ScrollController controller = ScrollController();

  _OrderScreenState() {
    init();
  }

  void init() async {
    super.initState();
    this.prefs = await SharedPreferences.getInstance();
    this.watched = json.decode(prefs.getString('watchList') ?? '[]');
    this.bloc = widget.bloc;
    this.ref = bloc.getWatchList();
    // print('Pressed $watched times.');
  }

  @override
  Widget build(BuildContext context) {
    ref = ref ?? (bloc ?? widget.bloc).getWatchList();
    print("Method Run, Order List");
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> map = snapshot.data.snapshot.value;
            return RefreshIndicator(
              onRefresh: () async {
                return await bloc.putWatchOrder();
              },
              child: DraggableScrollbar.semicircle(
                controller: controller,
                labelTextBuilder: (number) {
                  WatchItem item = WatchItem.fromMap(map[number ~/ 88.0]);
                  String text =
                      item.desc.length > 0 ? item.desc.first : "2012+";
                  if (item.type == "movie") {
                    text = item.desc.elementAt(1);
                  }
                  return Text(text.split(",").last);
                },
                child: _buildList(controller, context, map),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
            "${item.id + 1}: " + item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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
                // print(watched.toList());
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

  Widget getFilterHead(BuildContext context) {
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
            showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                title: Text("Filters"),
                children: <Widget>[
                  Text("Movies"),
                  Text("TV Shows"),
                  Text("Short Film"),
                  Text("Comic: Preludes"),
                  Text("Comic: Adaptation"),
                  Text("Comic: Commercials"),
                ],
              ),
            );
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

  Widget _buildList(
      ScrollController controller, BuildContext context, List<dynamic> map) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      controller: controller,
      padding: EdgeInsets.zero,
      itemCount: map.length,
      itemExtent: 88.0,
      addAutomaticKeepAlives: true,
      itemBuilder: (_, int index) {
        bool skipThis = false;
        WatchItem currentItem = WatchItem.fromMap(map[index]);
        if (!checkShow && watched.contains(currentItem.id)) {
          skipThis = true;
        }
        List<Widget> list = <Widget>[];
        // if (index == 0) {
        //   list.add(getFilterHead(context));
        //   list.add(showChecked());
        // }
        if (!skipThis) {
          list.add(getWatchItemTile(currentItem));
        }
        return Column(
          children: list,
        );
      },
    );
  }
}
