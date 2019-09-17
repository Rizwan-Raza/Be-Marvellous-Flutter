class Movie {
  String title;
  String subtitle;
  DateTime date;
  String desc;
  String image;

  Movie({this.title, this.subtitle, this.date, this.desc, this.image});

  Movie.fromMap(Map<dynamic, dynamic> map)
      : title = map['title'],
        subtitle = map['subtitle'],
        date = DateTime(
            map['date']['year'], map['date']['month'], map['date']['day']),
        desc = map['desc'],
        image = map['image'];

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
