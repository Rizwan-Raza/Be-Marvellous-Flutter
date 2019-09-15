import 'dart:convert';

class WatchItem {
  String type;
  String banner;
  String title;
  String subtitle;
  String synopsis;
  List<String> desc;

  WatchItem(
      {this.type,
      this.banner,
      this.title,
      this.subtitle,
      this.synopsis,
      this.desc});

  @override
  String toString() {
    String retVal =
        "Type: $type\nBanner: $banner\nTitle: $title\nSubtitle: $subtitle\nSynopsis: $synopsis\nDesc: \n";
    for (String d in desc) {
      retVal += "\t $d\n";
    }
    retVal += "--------------------------------------\n\n";
    return retVal;
  }

  Map<String, String> toJson() {
    return {
      "type": type,
      "banner": banner,
      "title": title,
      "subtitle": subtitle,
      "synopsis": synopsis,
      "desc": json.encode(desc),
    };
  }
}
