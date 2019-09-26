import 'package:firebase_database/firebase_database.dart';

class DataProvider {
  FirebaseDatabase _database;
  DatabaseReference _list;
  DatabaseReference _order;
  DatabaseReference _chars;
  DatabaseReference _heroes;
  DatabaseReference _villain;
  DatabaseReference _movie;
  DatabaseReference _tv;
  DataProvider() {
    _database = FirebaseDatabase.instance;
    _database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(10000000);
    _list = _database.reference().child("list");
    _chars = _database.reference().child("characters");
    _heroes = _database.reference().child("characters");
    _villain = _database.reference().child("characters");
    _movie = _database.reference().child("movies");
    _tv = _database.reference().child("tv");
  }

  FirebaseDatabase getDatabase() {
    return this._database;
  }

  DatabaseReference getWatchList() {
    return this._list;
  }

  DatabaseReference getCharacters() {
    return this._chars;
  }

  DatabaseReference getHeroes() {
    return this._heroes;
  }

  DatabaseReference getVillain() {
    return this._villain;
  }

  DatabaseReference getMovies() {
    return this._movie;
  }

  DatabaseReference getTvs() {
    return this._tv;
  }
}
