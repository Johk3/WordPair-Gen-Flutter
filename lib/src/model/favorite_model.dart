import 'dart:math';

import 'package:meta/meta.dart';

class Car {
  @required
  final int id;
  @required
  final String pair;

  Car({this.id, this.pair});

  Car.random(int inID, String inPair)
      : this.id = inID,
        this.pair = inPair;

  Car.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        pair = map['pair'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['pair'] = pair;
    return map;
  }
}