import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'database/database.dart';
import 'model/favorite_model.dart';
import 'dart:math';



class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>(); // Set doesnt allow duplicates
  int check = 0;

  // Cars are the "favorite wordpairs"
  @override
  void initState() {
    print("Running initState");
    super.initState();
    setupList();
  }

  final db = CarDatabase();
  List<Car> cars = [];

  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item){
        if(item.isOdd) return Divider();

        final index = item ~/ 2;

        if(index >= _randomWordPairs.length){
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, color: alreadySaved ? Colors.red : null),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _savedWordPairs.remove(pair);
          }else{
            // Adding the wordpairs into the DB
            var rng = new Random();
            int id = 0;
            for (var i = 0; i < 10; i++) {
              id += rng.nextInt(1000);
            }
            _savedWordPairs.add(pair);
            onFavoritePressed(id, pair.asPascalCase);
          }

        });
      },
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair){
            final wordpairExists = _savedWordPairs.contains(pair);

            return ListTile(
              title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
              trailing: Icon(wordpairExists ? Icons.visibility_off : Icons.visibility),
              onTap: (){
                // Ability to remove existing favorites
                setState(() {
                  if(wordpairExists){
                    _savedWordPairs.remove(pair);
                    onDelete(pair.asPascalCase);
                  }
                });
              },
            );
          });

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved WordPairs")
            ),
            body: ListView(children: divided)
          );
        }
      )
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("ChiefDirt"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList()
    );
  }

  onDelete(String id) async {
    await db.removeCar(id);
    db.fetchAll().then((carDb) => cars = carDb);
    setState(() {});
  }

  void onFavoritePressed(int id, String pair) async {
    var car = new Car.random(id, pair);
    await db.addCar(car);
    setupList();
  }

  void setupList() async {
    var _cars = await db.fetchAll();

    setState(() {
      cars = _cars;
    });

    // Check runs only at the start to initialize the Saved WordPairs
    if(check != 1){
          for(int i = 0; i < cars.length; i++){
      WordPair car = WordPair(cars[i].toMapForDb()["pair"], " ");
      final _alreadySaved = _savedWordPairs.contains(car);

      if(!_alreadySaved){
        _savedWordPairs.add(car);
        print("Added favorite");
    }
    }
    check++;
    }
  }

}