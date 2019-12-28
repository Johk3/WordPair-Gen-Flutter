import 'package:flutter/material.dart';
import 'random_words.dart';

void main() => runApp(MyApp());
// Continue youtube video at 23.18
// Video; https://www.youtube.com/watch?v=1gDhl4leEzA

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple),
      home: RandomWords()
    );
  }
}