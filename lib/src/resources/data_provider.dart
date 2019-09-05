import '../models/watch_item.dart';
import 'package:firebase_database/firebase_database.dart';

class DataProvider {
  final FirebaseDatabase database = FirebaseDatabase.instance;

  Future<List<WatchItem>> getWatchList() async {
    DataSnapshot dataSnapshot =
        await database.reference().child("order").once();
    print(dataSnapshot.toString());
    return null;
  }
}
