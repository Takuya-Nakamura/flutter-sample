import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:english_words/english_words.dart';

//root Widget..というイメージ...?
class ImageSamplePage extends StatelessWidget {
  /*2*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Material Design',
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min, //columnを上下中央に配置するために必要
          children: [
            Text("URLから読み込み"),
            Image.network(
                'https://www.pakutaso.com/shared/img/thumb/susipakuAB708IMGP1412_TP_V.jpg',
                width: 300),
            Text("assetから読み込み"),
            Image.asset(
              'images/logo.png',
            ),
          ],
        )),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: FractionallySizedBox(
  //         widthFactor: 0.5,
  //         heightFactor: 0.5,
  //         alignment: Alignment.centerLeft,
  //         child: Container(
  //           color: Colors.blue,
  //           child: Text("hello world", textDirection: TextDirection.ltr),
  //         )),
  //   );
  // }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/
          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]); /*5*/
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
