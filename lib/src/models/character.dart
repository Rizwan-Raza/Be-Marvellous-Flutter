class Character {
  String title;
  String subtitle;
  String microDesc;
  String desc;
  String image;

  Character({this.title, this.subtitle, this.microDesc, this.desc, this.image});

  Character.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        subtitle = map['subtitle'],
        microDesc = map['microDesc'],
        desc = map['desc'],
        image = map['image'];

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
