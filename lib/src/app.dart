import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'utilities/theme.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Setting Theme
    ThemeUtility.setLightTheme();

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
