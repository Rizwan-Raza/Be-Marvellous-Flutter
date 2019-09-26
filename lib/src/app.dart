import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white10, //or set color with: Color(0xFF0000FF)
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.red,
        systemNavigationBarIconBrightness: Brightness.dark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Be Marvellous",
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Product-Sans',
      ),
      home: Home(),
    );
  }
}
