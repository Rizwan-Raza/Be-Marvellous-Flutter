class NewsItem {
  int nid;
  String headline;
  String type;
  String category;
  DateTime timestamp;
  String link;
  String image;
  bool isVideo;

  NewsItem(
      {this.nid,
      this.headline,
      this.type,
      this.category,
      this.timestamp,
      this.link,
      this.image,
      this.isVideo});

  NewsItem.fromMap(Map<dynamic, dynamic> map)
      : nid = int.parse(map['nid'] ?? "0"),
        headline = map['headline'],
        type = map['content_type'] ?? map['type'] ?? "article",
        category =
            map['category'] is Map ? map['category']['title'] : map['category'],
        timestamp = DateTime.fromMillisecondsSinceEpoch(
            (map['timestamp'] is String
                    ? int.parse(map['timestamp'])
                    : (map['timestamp'] ?? 0)) *
                1000),
        link = map['link'] is Map ? map['link']['link'] : map['link'],
        image = map['image'] is Map ? map['image']['filename'] : map['image'],
        isVideo = map['play_button'] is String
            ? (map['play_button'] == "true" ? true : false)
            : map['play_button'] ?? map['isVideo'] is String
                ? (map['isVideo'] == "true" ? true : false)
                : map['isVideo'] ?? false;

  Map<String, String> toJson() {
    return {
      "nid": "$nid",
      "headline": headline,
      "type": type,
      "category": category,
      "timestamp": timestamp.millisecondsSinceEpoch.toString(),
      "link": link,
      "image": image,
      "isVideo": isVideo ? "true" : "false",
    };
  }

  String toString() {
    return this.toJson().toString();
  }
}
