import 'package:flutter/material.dart';
import './main_form.dart';
import './main_layout.dart';
import './list_view.dart';
import './main_image.dart';
import './main_pageview.dart';
import './main_connective.dart';
import './google_calendar_screen.dart';
import './export_screen.dart';
import './report_screen.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp()); // flutter runAppがウイジェット（コンポーネント）を画面表示する命令
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Sample'),
        ),
        body: Center(
          child: LinkList(),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/form': (BuildContext context) => new FormSamplePage(),
        '/list': (BuildContext context) => new ListViewSample(),
        '/layout': (BuildContext context) => new LayoutSamplePage(),
        '/image': (BuildContext context) => new ImageSamplePage(),
        '/pageView': (BuildContext context) => new PageViewSample(),
        '/connective': (BuildContext context) => new ConnectiveSamplePage(),
        '/google_calendar': (BuildContext context) => new GoogleCalendarScreen(),
        '/export': (BuildContext context) => new ExportScreen(),
        '/report': (BuildContext context) => new ReportScreen(),
      },
    );
  }
}

class LinkList extends StatelessWidget {
  @override
  void _handlePressed(page, context) {
    Navigator.of(context).pushNamed(page);
  }

  Widget build(BuildContext context) {
    Widget _buildRow(label, page) {
      return ListTile(
        title: TextButton(
          onPressed: () => _handlePressed(page, context),
          child: Text(label, style: TextStyle(fontSize: 18.0)),
        ),
      );
    }

    List<Widget> _buildRowList() {
      const pageList = [
        {'label': 'フォームサンプル', 'page': '/form'},
        {'label': 'リストビュー', 'page': '/list'},
        {'label': 'レイアウトサンプル', 'page': '/layout'},
        {'label': 'イメージサンプル', 'page': '/image'},
        {'label': '画面スワイプ移動', 'page': '/pageView'},
        {'label': 'オフラインチェック', 'page': '/connective'},
        {'label': 'Googleカレンダー連携', 'page': '/google_calendar'},
        {'label': 'エクスポート(ファイル出力)', 'page': '/export'},
        {'label': 'チャート', 'page': '/report'},
      ];
      // List<Widget> res = [];
      // pageList.forEach((e) => res.add(_buildRow(e['label'], e['page'])));
      // return res;
      return pageList.map((e) => _buildRow(e['label'], e['page'])).toList();
    }

    return Column(children: _buildRowList());
  }
}
