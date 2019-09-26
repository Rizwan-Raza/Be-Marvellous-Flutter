import 'package:be_marvellous/src/resources/auth.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  // int tabIndex = 1;
  List<Widget> pages = <Widget>[
    OrderScreen(key: PageStorageKey('Page1'), bloc: bloc, type: 1),
    OrderScreen(key: PageStorageKey('Page2'), bloc: bloc, type: 2),
    CharactersScreen(key: PageStorageKey('Page3'), bloc: bloc, type: 1),
    MediaScreen(key: PageStorageKey('Page4'), bloc: bloc, type: 1),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  // List<List<Widget>> tabs = <List<Widget>>[
  //   <Widget>[
  //     Tab(child: Text("All")),
  //     Tab(child: Text("Movies")),
  //     Tab(child: Text("TV Shows")),
  //     Tab(child: Text("Comics")),
  //     Tab(child: Text("Live Action")),
  //   ],
  //   <Widget>[
  //     Tab(child: Text("Coming Soon")),
  //     Tab(child: Text("Coming Soon")),
  //     Tab(child: Text("Coming Soon")),
  //   ],
  //   <Widget>[
  //     Tab(child: Text("All")),
  //     Tab(child: Text("Heroes")),
  //     Tab(child: Text("Villains")),
  //   ],
  //   <Widget>[
  //     Tab(child: Text("Movies")),
  //     Tab(child: Text("TV Shows")),
  //     Tab(child: Text("Wallpapers")),
  //   ],
  // ];
  // List<List<Widget>> nav = <List<Widget>>[
  //   <Widget>[
  //     OrderScreen(bloc: bloc, type: 1),
  //     OrderScreen(bloc: bloc, type: 2),
  //     OrderScreen(bloc: bloc, type: 3),
  //     OrderScreen(bloc: bloc, type: 4),
  //     OrderScreen(bloc: bloc, type: 5),
  //   ],
  //   <Widget>[
  //     Container(
  //         child: Center(child: Text("Coming Soon")), color: Colors.red[100]),
  //     Container(
  //         child: Center(child: Text("Coming Soon")), color: Colors.red[200]),
  //     Container(
  //         child: Center(child: Text("Coming Soon")), color: Colors.red[300]),
  //   ],
  //   <Widget>[
  //     CharactersScreen(bloc: bloc, type: 1),
  //     CharactersScreen(bloc: bloc, type: 2),
  //     CharactersScreen(bloc: bloc, type: 3),
  //   ],
  //   <Widget>[
  //     MediaScreen(bloc: bloc, type: 1),
  //     MediaScreen(bloc: bloc, type: 2),
  //     Container(
  //         child: Center(child: Text("Coming Soon")), color: Colors.red[100]),
  //   ],
  // ];
  @override
  Widget build(BuildContext context) {
    // Auth(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn())
    //     .signInWithGoogle()
    //     .then((FirebaseUser user) => print("Hi ${user.displayName}"));

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
      body: FloatingSearchBar(
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
          child: Icon(Icons.person),
        ),
        drawer: Drawer(
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
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
    );
  }

  onTabTapped(int index) {
    setState(() {
      this._selectedIndex = index;
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
