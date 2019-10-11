import 'package:be_marvellous/src/screens/sub-screens/games.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'sub-screens/media.dart';
import 'sub-screens/characters.dart';
import 'sub-screens/order.dart';
import '../blocs/bloc.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final Bloc bloc = Bloc();

  int _selectedIndex = 0;
  bool login = false;
  FirebaseUser user;
  Widget loginWidget;

  List<Widget> pages = <Widget>[
    OrderScreen(key: PageStorageKey('Page1'), bloc: bloc, type: 1),
    GamesScreen(key: PageStorageKey('Page2'), bloc: bloc, type: 2),
    CharactersScreen(key: PageStorageKey('Page3'), bloc: bloc, type: 1),
    MediaScreen(key: PageStorageKey('Page4'), bloc: bloc, type: 1),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    loginWidget = getLoginWidget();
    bloc.getUser().then((iUser) {
      setState(() {
        user = iUser;
        login = iUser != null;
      });
    });

    return Scaffold(
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.toc, title: "Watch List"),
          TabData(iconData: Icons.videogame_asset, title: "Games"),
          TabData(iconData: Icons.face, title: "Characters"),
          TabData(iconData: Icons.local_movies, title: "Media"),
        ],
        onTabChangedListener: onTabTapped,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 4.0),
        child: FloatingSearchBar(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 142.0,
              child: IndexedStack(
                index: _selectedIndex,
                children: pages.map((Widget p) {
                  return PageStorage(
                    child: p,
                    bucket: bucket,
                  );
                }).toList(),
              ),
            )
          ],
          trailing: CircleAvatar(
            child: login
                ? InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(user.displayName),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(user.email),
                                    Divider(
                                      height: 40.0,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      // height: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.red,
                                        child: Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          print("We have to do something here");
                                          bloc.logout().then((value) {
                                            setState(() {
                                              this.login = false;
                                              this.user = null;
                                            });
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(user.photoUrl)),
                      ),
                    ),
                  )
                : loginWidget,
          ),
          drawer: Drawer(
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'BE MARVELLOUS',
                        style: TextStyle(
                            fontFamily: 'Marvel',
                            fontSize: 60.0,
                            color: Colors.white),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                  ListTile(
                    title: Text('Watch List'),
                    leading: Icon(Icons.toc),
                    onTap: () {
                      onTabTapped(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Characters'),
                    leading: Icon(Icons.face),
                    onTap: () {
                      onTabTapped(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Movies'),
                    leading: Icon(Icons.movie),
                    onTap: () {
                      onTabTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('TV Shows'),
                    leading: Icon(Icons.tv),
                    onTap: () {
                      onTabTapped(3);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      // onTabTapped(1);
                    },
                  ),
                ],
              ),
            ),
          ),
          onChanged: (String value) {},
          onTap: () {},
          decoration: InputDecoration.collapsed(
            hintText: "Search here",
          ),
        ),
      ),
    );
  }

  onTabTapped(int index) {
    setState(() {
      this._selectedIndex = index;
    });
  }

  Widget getLoginWidget() {
    return IconButton(
        icon: Icon(Icons.person),
        onPressed: () async {
          user = await bloc.login();
          setState(() {
            user = user;
            login = true;
          });
        });
  }

  // Widget _getDefaultAppBar() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 6.0),
  //     child: Text(
  //       "BE MARVELLOUS",
  //       style: TextStyle(fontFamily: 'Marvel', fontSize: 28.0),
  //     ),
  //   );
  // }
}
