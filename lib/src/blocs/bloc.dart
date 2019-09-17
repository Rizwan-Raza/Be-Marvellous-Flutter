import 'dart:convert';
import '../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';
import '../resources/data_provider.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;

class Bloc {
  static final DataProvider provider = DataProvider();
  final DatabaseReference watchList = provider.getWatchList();
  final DatabaseReference watchOrder = provider.getWatchOrder();
  final DatabaseReference characters = provider.getCharacters();
  final DatabaseReference movies = provider.getMovies();

  DatabaseReference getWatchList() {
    return watchList;
  }

  DatabaseReference getWatchOrder() {
    return watchOrder;
  }

  DatabaseReference getCharacters() {
    return characters;
  }
  DatabaseReference getMovies() {
    return movies;
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
      watchOrder.child("${id++}").set(wItem.toJson());
    }
    print(id);
    provider.getDatabase().purgeOutstandingWrites();
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
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=character&sortDirection=desc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<Map<dynamic, dynamic>> list =
          json.decode(response.body)['data']['results']['data'];
      for (Map<dynamic, dynamic> item in list) {
        characters.child("${id++}").set(item);
      }
    }
    print(id);
    provider.getDatabase().purgeOutstandingWrites();
    return id;
  }

  Future<int> putMovies() async {
    List<String> source = <String>[
      'https://www.marvel.com/v1/pagination/grid_cards?limit=5000&entityType=movie&sortDirection=desc',
    ];

    int id = 0;
    for (String url in source) {
      Response response = await Client().get(url);
      List<Map<dynamic, dynamic>> list =
          json.decode(response.body)['data']['results']['data'];
      for (Map<dynamic, dynamic> item in list) {
        movies.child("${id++}").set(item);
      }
    }
    print(id);
    provider.getDatabase().purgeOutstandingWrites();
    return id;
  }
}
