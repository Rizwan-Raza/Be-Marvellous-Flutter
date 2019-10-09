import 'dart:convert';
import 'package:be_marvellous/src/models/character.dart';
import 'package:be_marvellous/src/models/character_detail.dart';
import 'package:be_marvellous/src/models/movies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;

class Bloc {
  FirebaseDatabase _database;
  FirebaseAuth _auth;
  DatabaseReference _watchList;
  DatabaseReference _characters;
  DatabaseReference _movies;
  DatabaseReference _tvs;
  DatabaseReference _char_details;
  DatabaseReference _wallpapers;
  Bloc() {
    _database = FirebaseDatabase.instance;
    _auth = FirebaseAuth.instance;
    _database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(10000000);
    _watchList = _database.reference().child("list");
    _characters = _database.reference().child("characters");
    _movies = _database.reference().child("movies");
    _tvs = _database.reference().child("tv");
    _char_details = _database.reference().child("char_details");
    _wallpapers = _database.reference().child("wallpapers");
    init();
  }

  void init() async {
    if (!((await _auth.currentUser()) != null)) {
      login();
    }
  }

  DatabaseReference getWatchList() {
    return _watchList;
  }

  DatabaseReference getCharacters() {
    return _characters;
  }

  DatabaseReference getMovies() {
    return _movies;
  }

  DatabaseReference getTvs() {
    return _tvs;
  }

  DatabaseReference getCharacterDetail() {
    return _char_details;
  }

  DatabaseReference getWallpapers() {
    return _wallpapers;
  }

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  Future<FirebaseUser> login() async {
    final GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;
    return (await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )))
        .user;
  }

  Future<int> putWatchOrder() async {
    List<String> paginatedSource = <String>[
      'https://mcureadingorder.com/reading_order.php?page=1&list_type=2&limit=250',
      'https://mcureadingorder.com/reading_order.php?page=2&list_type=2&limit=250',
      'https://mcureadingorder.com/reading_order.php?page=3&list_type=2&limit=250',
    ];

    List<dom.Element> listItems = <dom.Element>[];
    for (String url in paginatedSource) {
      Response response = await Client().get(url);
      response.headers['content-type'] = "text/html; charset=iso-8859-1";
      var document = parse(response.body, encoding: 'gzip');
      listItems.addAll(document.querySelectorAll(
          'body > table[width="990"] > tbody > tr > td[width="664"] > table > tbody > tr > td > div > table > tbody > tr > td[align="center"] > table > tbody > tr > td > table > tbody > tr[height="23px"] > td > table > tbody > tr'));
    }

    int id = 0;
    for (dom.Element item in listItems) {
      // print(item.innerHtml);
      var elem = parse(item.innerHtml);

      String typeSrc = getImageData(elem, 'img[alt="Flashback Issue"]');
      String type = typeSrc.substring(
          typeSrc.indexOf("left_") + 5, typeSrc.lastIndexOf("."));

      String banner =
          getImageData(elem, 'table > tbody > tr > td[width="17%"] > a > img');

      String title = getElementData(elem,
          'table > tbody > tr > td[width="57%"] > table > tbody > tr > td > a[border="0"]');

      var subTElem = elem.querySelectorAll(
          'table > tbody > tr > td[width="57%"] > table > tbody > tr > td')[1];
      String subtitle;
      if (subTElem != null) {
        subtitle = subTElem.text;
      }

      String synopsis = getElementData(elem,
          'table > tbody > tr > td[width="57%"] > table > tbody > tr > td > div');

      List<dom.Element> descElem = elem.querySelectorAll(
          'table > tbody > tr > td[width="26%"] > div > table > tbody > tr > td > span');
      List<String> desc = <String>[];
      for (dom.Element de in descElem) {
        desc.add(de.text
            .trim()
            .replaceAll("\n", " ")
            .replaceAll(RegExp(r' +'), ' '));
      }

      WatchItem wItem = WatchItem(
        id: id,
        type: type,
        banner: banner,
        title: title,
        subtitle: subtitle,
        synopsis: synopsis.trim(),
        desc: desc,
      );
      try {
        _watchList.child("${id++}").set(wItem.toJson());
      } catch (error) {
        print(error);
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  String getImageData(dom.Document elem, String selector) {
    dom.Element element = elem.querySelector(selector);
    if (element != null) {
      return element.attributes['src'];
    }
    return null;
  }

  String getElementData(dom.Document elem, String selector) {
    dom.Element element = elem.querySelector(selector);
    if (element != null) {
      return element.innerHtml;
    }
    return null;
  }

  Future<int> putCharacters() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=character&sortField=title&sortDirection=asc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<dynamic> list =
          json.decode(response.body)['data']['results']['data'];
      for (dynamic item in list) {
        try {
          String key = item['link']['link'];
          key = key.substring(key.lastIndexOf("/"));
          Map itemMap = Map.from(item);
          itemMap.addAll({"id": "${id++}", "type": "0"});
          _characters
              .child(key)
              .set(Character.fromMap(itemMap).toJson())
              .catchError(print);
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putHeroes() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=character&char_type=Hero&sortField=title&sortDirection=asc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<dynamic> list =
          json.decode(response.body)['data']['results']['data'];
      for (dynamic item in list) {
        try {
          String key = item['link']['link'];
          String context = item['link']['context'];
          key = key.substring(key.lastIndexOf("/"));
          Map itemMap = Map.from(item);
          itemMap.addAll({"type": "1", "context": context});
          _characters
              .child(key)
              .set(Character.fromMap(itemMap).toJson())
              .catchError(print);
          id++;
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putVillain() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=character&char_type=Villain&sortField=title&sortDirection=asc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<dynamic> list =
          json.decode(response.body)['data']['results']['data'];
      for (dynamic item in list) {
        try {
          String key = item['link']['link'];
          String context = item['link']['context'];
          key = key.substring(key.lastIndexOf("/"));
          Map itemMap = Map.from(item);
          itemMap.addAll({"type": "2", "context": context});

          _characters
              .child(key)
              .set(Character.fromMap(itemMap).toJson())
              .catchError(print);
          id++;
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putMovies() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=movie&sortField=release_date&sortDirection=asc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<dynamic> list =
          json.decode(response.body)['data']['results']['data'];
      for (dynamic item in list) {
        try {
          String key = item['link']['link'];
          key = key.substring(key.lastIndexOf("/"));
          _movies
              .child(key)
              .set(Movie.fromMap(item).toJson())
              .catchError(print);
          id++;
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putTvs() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=tv&sortField=release_date&sortDirection=asc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<dynamic> list =
          json.decode(response.body)['data']['results']['data'];
      for (dynamic item in list) {
        try {
          String key = item['link']['link'];
          key = key.substring(key.lastIndexOf("/"));
          _tvs.child(key).set(Movie.fromMap(item).toJson()).catchError(print);
          id++;
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putWallpapers() async {
    List<String> paginatedSource = <String>[
      'https://wallpaperaccess.com/marvel-phone',
      'https://wallpaperaccess.com/avengers-phone',
      'https://wallpaperaccess.com/deadpool-phone',
    ];

    List<dom.Element> listItems = <dom.Element>[];
    for (String url in paginatedSource) {
      Response response = await Client().get(url);
      response.headers['content-type'] = "text/html; charset=UTF-8";
      var document = parse(response.body, encoding: 'gzip');
      listItems.addAll(document
          .querySelectorAll('.pusher .flexbox.column.single_image > div[id]'));
    }

    int id = 0;
    for (dom.Element item in listItems) {
      // print(item.attributes['data-fullimg']);
      try {
        _wallpapers
            .child("${id++}")
            .set({"image": item.attributes['data-fullimg']});
      } catch (error) {
        print(error);
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putCharacterDetails(Character item) async {
    List<dom.Element> powerGrid = <dom.Element>[];
    List<dom.Element> shortBio = <dom.Element>[];
    Response response = await Client().get("https://marvel.com" +
        item.link +
        (item.context != "comic" ? "/in-comics" : ""));
    response.headers['content-type'] = "text/html; charset=UTF-8";
    var document = parse(response.body, encoding: 'gzip');
    powerGrid.addAll(
        document.querySelectorAll("body .power-grid .power-circle__wrapper"));
    shortBio.addAll(
        document.querySelectorAll("body .railExploreBio .bioheader__stats"));

    Map<String, String> charDetails = Map<String, String>();

    for (dom.Element dItem in powerGrid) {
      String currentPowerRating =
          dItem.querySelector(".power-circle__rating").text;
      String currentPowerLabel =
          dItem.querySelector(".power-circle__label").text;

      charDetails.addAll(
          {currentPowerLabel.trim().replaceAll(" ", "_"): currentPowerRating});
    }

    for (dom.Element dItem in shortBio) {
      String label = dItem.querySelector(".bioheader__label").text;
      String stat = dItem.querySelector(".bioheader__stat").text;
      // print(currentPowerRating);
      charDetails.addAll({label: stat});
    }
    CharacterDetail charD = CharacterDetail.fromMap(charDetails);
    _char_details
        .child(item.link.substring(item.link.lastIndexOf("/")))
        .set(charD.toJson())
        .catchError(print);
    return 0;
  }
}
