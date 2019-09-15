import 'package:firebase_database/firebase_database.dart';
import '../resources/data_provider.dart';

class Bloc {
  final DataProvider provider = DataProvider();

  DatabaseReference getWatchList() {
    return provider.getWatchList();
  }

  DatabaseReference getWatchOrder() {
    return provider.getWatchOrder();
  }
}
