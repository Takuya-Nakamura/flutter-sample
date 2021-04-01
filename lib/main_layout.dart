import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:english_words/english_words.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(LayoutSamplePage()); // flutter runAppがウイジェット（コンポーネント）を画面表示する命令
}

//root Widget..というイメージ...?
class LayoutSamplePage extends StatelessWidget {
  /*2*/
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Material Design',
  //     home: Scaffold(
  //       body: Center(
  //         child: Container(
  //           color: Colors.blue,
  //           width: 100,
  //           height: 100,
  //           child: Center(child:Text("Hello world"),)
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // 全画面背景白で 中心に100サイズの中に中心にテキストを表示
  // containerの中で
  // Widget build(BuildContext context) {
  //   return Container(
  //       color:Color(0xFFB74093),
  //       child: Center(
  //         child: Container(
  //           color: Colors.blue,
  //           padding: EdgeInsets.all(10.0),
  //           width: 200,
  //           height: 100,
  //           child: Center(child:Text("Hello world",  textDirection: TextDirection.ltr),)
  //         ),
  //       ),
  //   );
  // }

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
          child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.2,
              child: Container(
                color: Colors.blue,
                // width: 300.0,
                // height: 300.0,
              )),
        ),
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
