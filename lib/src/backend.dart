import 'package:flutter/material.dart';
import 'screens/interact_db.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pair Database'),
        ),
        body: MainPage(),
      ),
    );
  }
}