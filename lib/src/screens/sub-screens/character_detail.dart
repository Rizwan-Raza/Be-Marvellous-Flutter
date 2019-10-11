import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/character.dart';
import 'package:be_marvellous/src/models/character_detail.dart' as cd;
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
  bool refreshing = false;
  @override
  Widget build(BuildContext context) {
    print("Detail Screen");
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      refreshing = true;
                    });
                    // print("One from here 35");
                    widget.bloc.putCharacterDetails(widget.item).then((_) {
                      setState(() {
                        refreshing = false;
                      });
                    });
                  },
                )
              ],
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
        body: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            widget.item.subtitle != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${widget.item.subtitle}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32.0),
                        ),
                        Divider(),
                      ],
                    ),
                  )
                : Container(),
            widget.item.microDesc != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "${widget.item.microDesc}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Divider(),
                      ],
                    ),
                  )
                : Container(),
            widget.item.desc != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${widget.item.desc}"),
                  )
                : Container(),
            !refreshing
                ? StreamBuilder(
                    stream: widget.bloc
                        .getCharacterDetail()
                        .child(widget.item.link
                            .substring(widget.item.link.lastIndexOf("/")))
                        .onValue,
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.snapshot.value == null) {
                          // print("One from here 125");
                          widget.bloc.putCharacterDetails(widget.item);
                          return Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                              Text("Fetching Information"),
                            ],
                          ));
                        } else {
                          cd.CharacterDetail cditem =
                              cd.CharacterDetail.fromMap(
                                  snapshot.data.snapshot.value);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              buildPowerPanel(cditem),
                              buildBio(cditem),
                            ],
                          );
                        }
                      } else {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ));
                      }
                    },
                  )
                : Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                      Text("Refreshing Information"),
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  Widget buildBio(cd.CharacterDetail item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          item.gender != null
              ? getTileItem("Gender", item.gender, Icons.wc)
              : Container(),
          item.height != null
              ? getTileItem("Height", item.height, Icons.straighten)
              : Container(),
          item.weight != null
              ? getTileItem("Weight", item.weight, Icons.group_work)
              : Container(),
          item.hair != null
              ? getTileItem("Hair", item.hair, Icons.face)
              : Container(),
          item.eyes != null
              ? getTileItem("Eyes", item.eyes, Icons.visibility)
              : Container(),
          item.universe != null
              ? getTileItem("Universe", item.universe, Icons.language)
              : Container(),
          item.otherAliases != null
              ? getTileItem(
                  "Other Aliases", item.otherAliases, Icons.person_add)
              : Container(),
          item.education != null
              ? getTileItem("Education", item.education, Icons.school)
              : Container(),
          item.placeOfOrigin != null
              ? getTileItem("Place of Origin", item.placeOfOrigin, Icons.public)
              : Container(),
          item.identity != null
              ? getTileItem("Identity", item.identity, Icons.contacts)
              : Container(),
          item.knownRelatives != null
              ? getTileItem("Known Relatives", item.knownRelatives,
                  Icons.supervisor_account)
              : Container(),
          item.powers != null
              ? getTileItem("Powers", item.powers, Icons.stars)
              : Container(),
        ],
      ),
    );
  }

  Widget labelText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }

  Widget buildPowerPanel(cd.CharacterDetail item) {
    List<Widget> children = List<Widget>();
    if (item.durability != null) {
      children.add(powerItem("Durability", item.durability));
    }
    if (item.energy != null) {
      children.add(powerItem("Energy", item.energy));
    }
    if (item.fightingSkills != null) {
      children.add(powerItem("Fighting Skills", item.fightingSkills));
    }
    if (item.intelligence != null) {
      children.add(powerItem("Intelligence", item.intelligence));
    }
    if (item.speed != null) {
      children.add(powerItem("Speed", item.speed));
    }
    if (item.strength != null) {
      children.add(powerItem("Strength", item.strength));
    }
    return children.length > 0
        ? GridView(
            primary: false,
            shrinkWrap: true,
            children: children,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
          )
        : Container();
  }

  Widget powerItem(String text, String value) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            SizedBox(
              height: 48.0,
              width: 48.0,
              child: getCircle(value),
            ),
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget getTileItem(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
    );
  }

  Widget getCircle(String value) {
    MaterialColor tobeUse = Colors.red;
    switch (value) {
      case "7":
        tobeUse = Colors.teal;
        break;
      case "6":
        tobeUse = Colors.green;
        break;
      case "5":
        tobeUse = Colors.lightGreen;
        break;
      case "4":
        tobeUse = Colors.lime;
        break;
      case "3":
        tobeUse = Colors.yellow;
        break;
      case "2":
        tobeUse = Colors.orange;
        break;
      case "1":
        tobeUse = Colors.deepOrange;
        break;
    }
    return CircularProgressIndicator(
      strokeWidth: 16.0,
      value: double.parse(value) / 7,
      valueColor: AlwaysStoppedAnimation(tobeUse),
      backgroundColor: tobeUse[100],
    );
  }
}
