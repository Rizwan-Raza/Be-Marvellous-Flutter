import 'package:firebase_database/firebase_database.dart';

class DataProvider {
  FirebaseDatabase _database;
  DatabaseReference _list;
  DatabaseReference _order;
  DatabaseReference _chars;
  DatabaseReference _movie;
  DataProvider() {
    _database = FirebaseDatabase.instance;
    _database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(10000000);
    _list = _database.reference().child("order");
    _order = _database.reference().child("list");
    _chars = _database.reference().child("characters");
    _movie = _database.reference().child("movies");
  }

  FirebaseDatabase getDatabase() {
    return this._database;
  }

  DatabaseReference getWatchList() {
    return this._list;
  }

  DatabaseReference getWatchOrder() {
    return this._order;
  }

  DatabaseReference getCharacters() {
    return this._chars;
  }

  DatabaseReference getMovies() {
    return this._movie;
  }
}
