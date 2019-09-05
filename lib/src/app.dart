import 'package:flutter/material.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Be Marvellous",
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Product-Sans',
      ),
      home: Home(),
    );
  }
}
