import 'package:be_marvellous/src/models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart';

class CharacterDetail extends StatefulWidget {
  const CharacterDetail({this.item, Key key}) : super(key: key);
  final Character item;

  @override
  _CharacterDetailState createState() => _CharacterDetailState();
}

class _CharacterDetailState extends State<CharacterDetail> {
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
                    "${widget.item.title}",
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
                            (widget.item.image ?? "default/explore-no-img.jpg"),
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
                widget.item.subtitle != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.item.subtitle}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 36.0),
                          ),
                          Divider(),
                        ],
                      )
                    : Container(),
                widget.item.microDesc != null
                    ? Column(
                        children: <Widget>[
                          Text(
                            "${widget.item.microDesc}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Divider(),
                        ],
                      )
                    : Container(),
                widget.item.desc != null
                    ? Text("${widget.item.desc}")
                    : Container(),
                RaisedButton(
                  child: Text("Fetch Details"),
                  onPressed: () {
                    fetchDetail(widget.item.link);
                  },
                ),
              ],
            ),
          )),
    );
  }

  void fetchDetail(String link) async {
    List<dom.Element> powerGrid = <dom.Element>[];
    List<dom.Element> shortBio = <dom.Element>[];
    Response response = await Client().get("https://marvel.com" + link);
    response.headers['content-type'] = "text/html; charset=UTF-8";
    var document = parse(response.body, encoding: 'gzip');
    powerGrid.addAll(
        document.querySelectorAll("body .power-grid .power-circle__wrapper"));
    shortBio.addAll(document.querySelectorAll("body .railExploreBio"));

    for (dom.Element item in powerGrid) {
      String currentPowerRating =
          item.querySelector(".power-circle__rating").text;
      String currentPowerLabel =
          item.querySelector(".power-circle__label").text;

      print(currentPowerRating);
      print(currentPowerLabel
          .trim()
          .split(" ")
          .map((s) => '${s.substring(0, 0).toUpperCase()}${s.substring(1)}')
          .join(""));
    }

    for (dom.Element item in powerGrid) {
      // String currentPowerRating =
      //     item.querySelector(".power-circle__rating").text;
      // String currentPowerLabel =
      //     item.querySelector(".power-circle__label").text;

      // print(currentPowerRating);
      print(item.innerHtml);
    }
  }
}
