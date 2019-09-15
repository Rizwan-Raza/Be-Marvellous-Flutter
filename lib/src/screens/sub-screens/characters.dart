import 'dart:convert';
import 'dart:io';

import 'package:be_marvellous/src/blocs/bloc_provider.dart';
import 'package:be_marvellous/src/models/list_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:html/dom.dart' as dom;

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = BlocProvider.of(context).getWatchOrder();

    return Center(
      child: RaisedButton.icon(
        icon: Icon(Icons.list),
        onPressed: () async {
          print("Starting.");
          Response response = await Client().get(
              'https://mcureadingorder.com/reading_order.php?page=1&list_type=2&limit=250');
          response.headers['content-type'] = "text/html; charset=iso-8859-1";
          var document = parse(response.body, encoding: 'gzip');
          List<dom.Element> tbody = document.querySelectorAll(
              'body > table[width="990"] > tbody > tr > td[width="664"] > table > tbody > tr > td > div > table > tbody > tr > td[align="center"] > table > tbody > tr > td > table > tbody > tr[height="23px"] > td > table > tbody > tr');
          int id = 0;
          for (dom.Element item in tbody) {
            // print(item.innerHtml);
            var elem = parse(item.innerHtml);

            String typeSrc = getImageData(elem, 'img[alt="Flashback Issue"]');
            String type = typeSrc.substring(
                typeSrc.indexOf("left_") + 5, typeSrc.lastIndexOf("."));

            String banner = getImageData(
                elem, 'table > tbody > tr > td[width="17%"] > a > img');

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
              type: type,
              banner: banner,
              title: title,
              subtitle: subtitle,
              synopsis: synopsis.trim(),
              desc: desc,
            );
            ref.child("${id++}").set(wItem.toJson());
            print(wItem);
          }
          print("Done");
        },
        label: Text("Fetch List"),
      ),
    );
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
}
