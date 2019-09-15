import '../blocs/bloc_provider.dart';
import '../screens/sub-screens/characters.dart';
import 'package:flutter/material.dart';
import 'sub-screens/order.dart';
import 'search.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  List<Widget> nav = <Widget>[
    OrderScreen(),
    Container(
        child: Center(
          child: Text("Coming Soon"),
        ),
        color: Colors.red[100]),
    CharactersScreen(),
    Container(
        child: Center(
          child: Text("Coming Soon"),
        ),
        color: Colors.red[300]),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: this.index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.toc),
              title: Text("Watch List"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              title: Text("Games"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              title: Text("Characters"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              title: Text("Media"),
            ),
          ],
        ),
        body: nav[this.index],
      ),
    );
  }

  onTabTapped(int index) {
    setState(() {
      this.index = index;
    });
  }

  Widget _getDefaultAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        "BE MARVELLOUS",
        style: TextStyle(
          fontFamily: 'Marvel',
          fontSize: 28.0,
        ),
      ),
    );
  }
}
