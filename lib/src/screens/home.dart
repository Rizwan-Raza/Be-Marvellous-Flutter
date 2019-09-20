import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'sub-screens/media.dart';
import 'sub-screens/characters.dart';
import 'sub-screens/order.dart';
import 'search.dart';
import '../blocs/bloc.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final Bloc bloc = Bloc();
  Widget appBarTitle = Padding(
    padding: const EdgeInsets.only(top: 6.0),
    child: Text(
      "BE MARVELLOUS",
      style: TextStyle(
        fontFamily: 'Marvel',
        fontSize: 28.0,
      ),
    ),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  bool _isSearching = false;
  String _searchText = "";

  final TextEditingController _searchQuery = new TextEditingController();

  int index = 0;
  int tabIndex = 1;
  List<List<Widget>> tabs = <List<Widget>>[
    <Widget>[
      Tab(child: Text("All")),
      Tab(child: Text("Movies")),
      Tab(child: Text("TV Shows")),
      Tab(child: Text("Comics")),
      Tab(child: Text("Live Action")),
    ],
    <Widget>[
      Tab(child: Text("Coming Soon")),
      Tab(child: Text("Coming Soon")),
      Tab(child: Text("Coming Soon")),
    ],
    <Widget>[
      Tab(child: Text("All")),
      Tab(child: Text("Heroes")),
      Tab(child: Text("Villains")),
    ],
    <Widget>[
      Tab(child: Text("Movies")),
      Tab(child: Text("TV Shows")),
      Tab(child: Text("Wallpapers")),
    ],
  ];
  List<Widget> nav = <Widget>[
    TabBarView(
      children: <Widget>[
        OrderScreen(bloc: bloc, type: 1),
        OrderScreen(bloc: bloc, type: 2),
        OrderScreen(bloc: bloc, type: 3),
        OrderScreen(bloc: bloc, type: 4),
        OrderScreen(bloc: bloc, type: 5),
      ],
    ),
    TabBarView(
      children: <Widget>[
        Container(
            child: Center(child: Text("Coming Soon")), color: Colors.red[100]),
        Container(
            child: Center(child: Text("Coming Soon")), color: Colors.red[200]),
        Container(
            child: Center(child: Text("Coming Soon")), color: Colors.red[300]),
      ],
    ),
    TabBarView(
      children: <Widget>[
        CharactersScreen(bloc: bloc, type: 1),
        CharactersScreen(bloc: bloc, type: 2),
        CharactersScreen(bloc: bloc, type: 3),
      ],
    ),
    TabBarView(
      children: <Widget>[
        MediaScreen(bloc: bloc, type: 1),
        MediaScreen(bloc: bloc, type: 2),
        Container(
            child: Center(child: Text("Coming Soon")), color: Colors.red[100]),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs[this.index].length,
      child: Scaffold(
          appBar: AppBar(
            title: appBarTitle,
            actions: <Widget>[
              IconButton(
                  icon: actionIcon,
                  onPressed: () {
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        this.actionIcon = Icon(
                          Icons.close,
                          color: Colors.white,
                        );
                        this.appBarTitle = Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: TextField(
                            autofocus: true,
                            controller: _searchQuery,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        );
                        _isSearching = true;
                      } else {
                        this.actionIcon = new Icon(
                          Icons.search,
                          color: Colors.white,
                        );
                        this.appBarTitle = _getDefaultAppBar();
                        _isSearching = false;
                        _searchQuery.clear();
                      }
                    });
                  }),
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchList()),
                  );
                },
              ),
            ],
            bottom: TabBar(isScrollable: true, tabs: tabs[this.index]),
          ),
          drawer: Drawer(
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
          bottomNavigationBar: FancyBottomNavigation(
            barBackgroundColor: Colors.red,
            activeIconColor: Colors.red,
            circleColor: Colors.white,
            inactiveIconColor: Colors.white70,
            textColor: Colors.white,
            tabs: [
              TabData(iconData: Icons.toc, title: "Watch List"),
              TabData(iconData: Icons.videogame_asset, title: "Games"),
              TabData(iconData: Icons.face, title: "Characters"),
              TabData(iconData: Icons.local_movies, title: "Media"),
            ],
            onTabChangedListener: onTabTapped,
          ),

          // BottomNavigationBar(
          //       type: BottomNavigationBarType.fixed,
          //       onTap: onTabTapped,
          //       currentIndex: this.index,
          //       items: [
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.toc),
          //           title: Text("Watch List"),
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.videogame_asset),
          //           title: Text("Games"),
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.face),
          //           title: Text("Characters"),
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.local_movies),
          //           title: Text("Media"),
          //         ),
          //       ],
          //     ),
          body: nav[this.index]),
    );
  }

  onTabTapped(int index) {
    setState(() {
      this.index = index;
      this.tabIndex = 0;
    });
  }

  Widget _getDefaultAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        "BE MARVELLOUS",
        style: TextStyle(fontFamily: 'Marvel', fontSize: 28.0),
      ),
    );
  }
}
