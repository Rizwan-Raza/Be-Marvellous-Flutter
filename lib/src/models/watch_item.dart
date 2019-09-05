class WatchItem {
  int id;
  int type;
  String title;

  WatchItem({this.id, this.type, this.title});

  WatchItem.fromMap(Map<dynamic, dynamic> data, int id)
      : this(id: id, type: data['type'], title: data['title']);
}
