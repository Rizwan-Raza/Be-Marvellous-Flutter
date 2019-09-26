import 'package:be_marvellous/src/models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CharacterDetail extends StatelessWidget {
  const CharacterDetail({this.item, Key key}) : super(key: key);
  final Character item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    "${item.title}",
                    style: TextStyle(
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 10.0,
                            offset: Offset.zero)
                      ],
                    ),
                  ),
                  background: CachedNetworkImage(
                    color: Color.fromRGBO(0, 0, 0, 0.66),
                    colorBlendMode: BlendMode.plus,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://terrigen-cdn-dev.marvel.com/content/prod/1x/" +
                            (item.image ?? "default/explore-no-img.jpg"),
                    placeholder: (context, url) =>
                        Image.asset("assets/img/nothing.jpg"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/img/back.png"),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                item.subtitle != null
                    ? Column(
                        children: <Widget>[
                          Text(
                            "${item.subtitle}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 36.0),
                          ),
                          Divider(),
                        ],
                      )
                    : Container(),
                item.microDesc != null
                    ? Column(
                        children: <Widget>[
                          Text(
                            "${item.microDesc}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Divider(),
                        ],
                      )
                    : Container(),
                item.microDesc != null ? Text("${item.desc}") : Container(),
              ],
            ),
          )),
    );
  }
}
