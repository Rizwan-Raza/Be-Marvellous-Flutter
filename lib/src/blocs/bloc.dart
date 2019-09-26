import 'dart:convert';
import 'package:be_marvellous/src/models/character.dart';
import 'package:be_marvellous/src/models/movies.dart';

import '../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import '../resources/data_provider.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;

class Bloc {
  static final DataProvider provider = DataProvider();
  final DatabaseReference watchList = provider.getWatchList();
  final DatabaseReference characters = provider.getCharacters();
  final DatabaseReference heroes = provider.getHeroes();
  final DatabaseReference villain = provider.getVillain();
  final DatabaseReference movies = provider.getMovies();
  final DatabaseReference tvs = provider.getTvs();

  DatabaseReference getWatchList() {
    return watchList;
  }

  DatabaseReference getCharacters() {
    return characters;
  }

  DatabaseReference getHeroes() {
    return heroes;
  }

  DatabaseReference getVillain() {
    return villain;
  }

  DatabaseReference getMovies() {
    return movies;
  }

  DatabaseReference getTvs() {
    return tvs;
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
        watchList.child("${id++}").set(wItem.toJson());
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
          characters
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
          key = key.substring(key.lastIndexOf("/"));
          Map itemMap = Map.from(item);
          itemMap.addAll({"type": "1"});
          heroes
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
          key = key.substring(key.lastIndexOf("/"));
          Map itemMap = Map.from(item);
          itemMap.addAll({"type": "2"});
          villain
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
          movies.child(key).set(Movie.fromMap(item).toJson()).catchError(print);
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
          tvs.child(key).set(Movie.fromMap(item).toJson()).catchError(print);
        } catch (error) {
          print(error);
        }
      }
    }
    print(id);
    // provider.getDatabase().purgeOutstandingWrites();
    return id;
  }
}
