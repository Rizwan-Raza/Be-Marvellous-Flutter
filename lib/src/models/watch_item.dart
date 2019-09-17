import 'dart:convert';

class WatchItem {
  int id;
  String type;
  String banner;
  String title;
  String subtitle;
  String synopsis;
  List<dynamic> desc;

  WatchItem(
      {this.id,
      this.type,
      this.banner,
      this.title,
      this.subtitle,
      this.synopsis,
      this.desc});

  @override
  String toString() {
    String retVal =
        "ID: $id\nType: $type\nBanner: $banner\nTitle: $title\nSubtitle: $subtitle\nSynopsis: $synopsis\nDesc: \n";
    for (String d in desc) {
      retVal += "\t $d\n";
    }
    retVal += "--------------------------------------\n\n";
    return retVal;
  }

  Map<String, String> toJson() {
    return {
      "id": "$id",
      "type": type,
      "banner": banner,
      "title": title,
      "subtitle": subtitle,
      "synopsis": synopsis,
      "desc": json.encode(desc),
    };
  }

  WatchItem.fromMap(Map<dynamic, dynamic> map)
      : id = int.parse(map['id']),
        type = map['type'],
        banner = map['banner'],
        title = map['title'],
        subtitle = map['subtitle'],
        synopsis = map['synopsis'],
        desc = json.decode(map['desc']);

  String getType() {
    switch (type) {
      case "movie":
        return "Movie";
      case "tv":
        return "TV Show";
      case "comic":
        return "Comic";
      case "short_film":
        return "Short Film";
      case "book":
        return "Book";
      default:
        return type;
    }
  }
}
