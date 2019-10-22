import 'package:be_marvellous/src/blocs/bloc.dart';
import 'package:be_marvellous/src/models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  final Bloc bloc;
  const NewsScreen({this.bloc, Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Bloc bloc;
  DatabaseReference ref;

  @override
  Widget build(BuildContext context) {
    this.bloc = widget.bloc;
    this.ref = bloc.getNews();
    bloc.putNews();
    print("Method Run, News List");
    return Column(
      children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.putNews();
            },
            child: FirebaseAnimatedList(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              query: ref ??
                  ((bloc == null) ? widget.bloc.getNews() : bloc.getNews()),
              sort: (a, b) => b.key.compareTo(a.key),
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int x) {
                NewsItem currentItem = NewsItem.fromMap(snapshot.value);
                return getNewsItemTile(currentItem);
              },
              defaultChild: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }

  Widget getNewsItemTile(NewsItem item) {
    return Column(
      children: <Widget>[
        Divider(
          height: 0,
        ),
        ListTile(
          title: Text(item.headline),
          subtitle: Text(item.category),
          leading: CachedNetworkImage(
            imageUrl: "https://terrigen-cdn-dev.marvel.com/content/prod/1x/" +
                item.image,
          ),
          trailing: Icon(
              item.type == "article" ? Icons.description : Icons.play_arrow),
        )
      ],
    );
  }
}
