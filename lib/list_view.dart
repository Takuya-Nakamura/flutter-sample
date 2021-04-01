import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:english_words/english_words.dart';

// void main() => runApp(MyApp()); /*1*/
void main() {
  // debugPaintSizeEnabled = true;
  runApp(ListViewSample()); // flutter runAppがウイジェット（コンポーネント）を画面表示する命令
}

//root Widget..というイメージ...?
class ListViewSample extends StatelessWidget {
  /*2*/
  @override
  Widget build(BuildContext context) {
    // ウイジェットのUIを作成する
    /*3*/

    return MaterialApp(
      /*4*/
      home: Scaffold(
        // アプリケーションバーやタイトル、ホーム画面のウィジェットツリーを保持する、bodyプロパティを提供します。
        /*5*/
        appBar: AppBar(
          title: Text('List View'),
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
        ),

        body: Center(
          /*7*/
          child: RandomWords(),
        ),
      ),
    );

    // return MaterialApp(title: 'Startup Name Generator', home: RandomWords());
  }
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
