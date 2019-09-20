class Movie {
  String title;
  String subtitle;
  DateTime date;
  String desc;
  String image;

  Movie({this.title, this.subtitle, this.date, this.desc, this.image});

  Movie.fromMap(Map<dynamic, dynamic> map)
      : title = map['headline'] ?? map['title'],
        subtitle = map['secondary_text'] ?? map['subtitle'],
        date = ((map['date'] is Map)
            ? DateTime(
                int.parse(map['date']['year'] ?? "1970"),
                int.parse(map['date']['month'] ?? "1"),
                int.parse(map['date']['day'] ?? "1"),
              )
            : map['date']),
        desc = map['description'] ?? map['desc'],
        image =
            ((map['image'] is Map) ? map['image']['filename'] : map['image']);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "date": {
        "year": "${date.year}",
        "month": "${date.month}",
        "day": "${date.day}",
      },
      "desc": desc,
      "image": image
    };
  }
}
