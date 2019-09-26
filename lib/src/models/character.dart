class Character {
  int id;
  String title;
  String subtitle;
  String microDesc;
  String desc;
  String image;
  int type;
  String link;

  Character(
      {this.id,
      this.title,
      this.subtitle,
      this.microDesc,
      this.desc,
      this.image,
      this.type,
      this.link});

  Character.fromMap(Map<dynamic, dynamic> map)
      : id = int.parse(map['id'] ?? "0"),
        title = map['headline'] ?? map['title'],
        subtitle = map['secondary_text'] ?? map['subtitle'],
        microDesc = map['micro_description'] ?? map['microDesc'],
        desc = map['description'] ?? map['desc'],
        image =
            ((map['image'] is Map) ? map['image']['filename'] : map['image']),
        type = int.parse(map['type'] ?? "0"),
        link = ((map['link'] is Map) ? map['link']['link'] : map['link']);

  Map<String, String> toJson() {
    return {
      "id": "$id",
      "title": title,
      "subtitle": subtitle,
      "microDesc": microDesc,
      "desc": desc,
      "image": image,
      "type": "$type",
      "link": link
    };
  }
}
