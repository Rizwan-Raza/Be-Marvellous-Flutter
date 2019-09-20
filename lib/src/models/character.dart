class Character {
  String title;
  String subtitle;
  String microDesc;
  String desc;
  String image;

  Character({this.title, this.subtitle, this.microDesc, this.desc, this.image});

  Character.fromMap(Map<dynamic, dynamic> map)
      : title = map['headline'] ?? map['title'],
        subtitle = map['secondary_text'] ?? map['subtitle'],
        microDesc = map['micro_description'] ?? map['microDesc'],
        desc = map['description'] ?? map['desc'],
        image =
            ((map['image'] is Map) ? map['image']['filename'] : map['image']);

  Map<String, String> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "microDesc": microDesc,
      "desc": desc,
      "image": image
    };
  }
}
