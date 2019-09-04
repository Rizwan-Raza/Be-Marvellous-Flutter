import 'package:flutter/material.dart';
import 'screens/order.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Be Marvellous",
      home: OrderScreen(),
    );
  }
}
