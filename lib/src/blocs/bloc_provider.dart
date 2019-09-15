import 'bloc.dart';
import 'package:flutter/material.dart';

class BlocProvider extends InheritedWidget {
  BlocProvider({Key key, Widget child})
      : bloc = Bloc(),
        super(key: key, child: child);

  final Bloc bloc;

  static Bloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return true;
  }
}
