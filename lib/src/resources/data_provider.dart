import 'package:firebase_database/firebase_database.dart';

class DataProvider {
  DatabaseReference list = FirebaseDatabase.instance.reference().child("order");
  DatabaseReference order = FirebaseDatabase.instance.reference().child("list");

  DatabaseReference getWatchList() {
    return this.list;
  }

  DatabaseReference getWatchOrder() {
    return this.order;
  }
}
