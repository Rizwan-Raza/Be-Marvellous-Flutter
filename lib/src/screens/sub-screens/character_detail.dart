import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CharacterDetail extends StatefulWidget {
  const CharacterDetail({this.bloc, this.item, Key key}) : super(key: key);
  final Character item;
  final Bloc bloc;

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
                StreamBuilder(
                  stream: widget.bloc
                      .getCharacterDetail()
                      .child(widget.item.link
                          .substring(widget.item.link.lastIndexOf("/")))
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return Text("Loading");
                    }
                  },
                  initialData: Center(child: CircularProgressIndicator()),
                ),
                RaisedButton(
                  child: Text("Fetch Details"),
                  onPressed: () {
                    // print(widget.item.link);
                    widget.bloc.putCharacterDetails(widget.item);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
