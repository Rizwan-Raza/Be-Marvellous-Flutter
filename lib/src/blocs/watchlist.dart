import 'package:be_marvellous/src/models/watch_item.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/data_provider.dart';

class WatchListBloc {
  final DataProvider provider = DataProvider();

  final PublishSubject<List<WatchItem>> watchList =
      PublishSubject<List<WatchItem>>();

  Observable<List<WatchItem>> get topIds => watchList.stream;

  getWatchList() async {
    final list = await provider.getWatchList();
    watchList.sink.add(list);
  }
}
