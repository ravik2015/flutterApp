// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
//import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:firstapp/FirstScreen.dart';
import 'package:firstapp/SecondScreen.dart';

// void main() {
//   runApp(new FirstFragment());
// }

class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RandomWords();
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _saved = Set<WordPair>();

  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    print(_saved);
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text('Startup Name Generator'),
      //   actions: <Widget>[
      //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
      //   ],
      // ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () async {
        // obtain shared preferences
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
          _pushSaved();
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                onTap: () {
                  _pushCardView();
                },
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.list), onPressed: _pushDetails),
              ],
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushDetails() {
    Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => new FirstScreen()),
        );
  }

  void _pushCardView() {
    Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => new SecondScreen()),
        );
  }
}

// import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';
// import 'package:firstapp/FirstScreen.dart';
// import 'package:firstapp/SecondScreen.dart';

// class FirstFragment extends StatelessWidget {
//   @override
//   final _suggestions = <WordPair>[];

//   final _saved = Set<WordPair>();

//   final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

//   @override
//   Widget build(BuildContext context) {
//     print(_saved);
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Startup Name Generator'),
//         actions: <Widget>[
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }

//   Widget _buildSuggestions() {
//     return new ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemBuilder: (context, i) {
//         if (i.isOdd) return new Divider();

//         final index = i ~/ 2;
//         if (index >= _suggestions.length) {
//           _suggestions.addAll(generateWordPairs().take(10));
//         }
//         return _buildRow(_suggestions[index]);
//       },
//     );
//   }

//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return new ListTile(
//       title: new Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: Icon(
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) {
//           final tiles = _saved.map(
//             (pair) {
//               return ListTile(
//                 title: Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//                 onTap: () {
//                   _pushCardView();
//                 },
//               );
//             },
//           );
//           final divided = ListTile
//               .divideTiles(
//                 context: context,
//                 tiles: tiles,
//               )
//               .toList();
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Saved Suggestions'),
//               actions: <Widget>[
//                 IconButton(icon: Icon(Icons.list), onPressed: _pushDetails),
//               ],
//             ),
//             body: ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }

//   void _pushDetails() {
//     Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => new FirstScreen()),
//         );
//   }

//   void _pushCardView() {
//     Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => new SecondScreen()),
//         );
//   }
// }
