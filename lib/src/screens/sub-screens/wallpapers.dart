import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

class Wallpapers extends StatefulWidget {
  final Query ref;
  final Bloc bloc;
  Wallpapers({this.ref, this.bloc, Key key}) : super(key: key);

  _WallpapersState createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers>
    with AutomaticKeepAliveClientMixin<Wallpapers> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  Stream<String> progressString;
  String res = "0%";
  bool downloading = false;
  var result = "Waiting to set wallpaper";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: <Widget>[
      StreamBuilder(
          stream: widget.ref.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> map = snapshot.data.snapshot.value;
              return RefreshIndicator(
                onRefresh: () async {
                  return await widget.bloc.putWallpapers();
                },
                child: GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: map.length,
                  reverse: false,
                  itemBuilder: (context, int index) {
                    // print(map[index]);
                    String link = map[index]['image'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          res = "0%";
                          downloading = true;
                        });
                        progressString = Wallpaper.ImageDownloadProgress(
                            "https://wallpaperaccess.com$link");
                        progressString.listen((data) {
                          setState(() {
                            res = data;
                          });
                          print("DataReceived: " + data);
                        }, onDone: () async {
                          system = await Wallpaper.systemScreen();
                          setState(() {
                            downloading = false;
                            system = system;
                          });
                          print("Task Done");
                        }, onError: (error) {
                          setState(() {
                            downloading = false;
                          });
                          print("Some Error");
                        });
                      },
                      child: GridTile(
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width / 2,
                          height: (MediaQuery.of(context).size.width / 4) * 3,
                          fit: BoxFit.cover,
                          imageUrl: "https://wallpaperaccess.com$link",
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/img/back.png"),
                        ),
                      ),
                    );
                  },
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2 / 3),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      downloading
          ? Container(
              color: Colors.black45,
              child: Center(
                child: Card(
                  elevation: 5.0,
                  color: Colors.white,
                  child: Container(
                    height: 150.0,
                    width: 200.0,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 20.0),
                        Text(
                          "Downloading: $res",
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Text("")
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
