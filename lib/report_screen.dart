import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'tooltip_symbol_renderer.dart';

import '../models/client.dart';
import '../models/project.dart';

import '../util/ext.dart';
import '../util/constant.dart';


/*
期間
対象 (filter)
  Client, Project, Tag

合計時間
  30h / 30万円
時間のバーグラフ

Client毎の時間リスト
  Naia 10h 30%
  あすけん 20h 70%
Clientの割合グラフ（円グラフ）

Project毎の時間リスト
Projectの割合グラフ（円グラフ）

*/


class OrdinalSales {
  final String year;
  final int sales;
  // final String color;
  OrdinalSales(this.year, this.sales);
}
class TimeSeriesSales {
  final DateTime time;
  final int sales;
  TimeSeriesSales(this.time, this.sales);
}
class LinearSales {
  final int year;
  final int sales;
  final Color color;
  LinearSales(this.year, this.sales, this.color);
}


class ReportScreen extends StatefulWidget {
  const ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}


class _ReportScreenState extends State<ReportScreen> {

  final List<Client> _clients = [];
  final List<Project> _projects = [];


  // サンプルデータ
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {

    List<OrdinalSales> data = [];
    for (var i=0; i<32; i++) {
      data.add(OrdinalSales('${i+1}', Random().nextInt(10)));
    }

    // final data = [
    //   OrdinalSales('2014', 5, '#0E46FE'),
    //   OrdinalSales('2015', 25, '#0E46FE'),
    //   OrdinalSales('2016', 120, '#0E46FE'),
    //   OrdinalSales('2017', 75, '#0E46FE'),
    //   OrdinalSales('2018', 75, '#0E46FE'),
    //   OrdinalSales('2019', 75, '#0E46FE'),
    //   OrdinalSales('2020', 75, '#0E46FE'),
    // ];
    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        // colorFn: (OrdinalSales sales, _) => Color.fromHex(code: sales.color),
        data: data,
        // labelAccessorFn: (OrdinalSales sales, _) {
        //   return '';
        // }
      )
    ];
  }
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData2() {
    List<TimeSeriesSales> data = [];
    for (var i=0; i<32; i++) {
      final date = DateTime(2022, 1, i+1);
      data.add(TimeSeriesSales(date, Random().nextInt(10)));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        // colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  static List<charts.Series<LinearSales, int>> _createSampleData3() {
    final data = [
      LinearSales(1, 50, Colors.blue),
      LinearSales(2, 75, Colors.blue),
      LinearSales(3, 25, Colors.blue),
      LinearSales(4, 5, Colors.blue),
    ];
    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        // colorFn: (LinearSales sales, _) => sales.color,
        data: data,
        labelAccessorFn: (LinearSales sales, _) {
          // if (sales.sales < 10) { return ''; }
          return '${sales.year}組 ${sales.sales}';
        } 
      )
    ];
  }


  @override
  void initState() {
    super.initState();

    for (var i=0; i<3; i++) {
      var client = Client(name: '株式会社 $i');
      _clients.add(client);

      for (var j=0; j<5; j++) {
        var project = Project(name: 'プロジェクト $i - $j', hexColor: 'FFDDDDDD');
        project.client = client;
        _projects.add(project);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('レポート'),
        // leading: Ext.drawerMenu(),
        actions: [
            TextButton(
              child: const Icon(Icons.ios_share, color: Colors.white),
              onPressed: (){}
            ),

          // SizedBox(
          //   width: 30,
            // child: TextButton(
            //   child: const Icon(Icons.calendar_today, color: Colors.white),
            //   onPressed: (){}
            // ),
          // ),
          // SizedBox(
          //   width: 30,
          //   child: TextButton(
          //     child: const Icon(Icons.tune_outlined, color: Colors.white),
          //     onPressed: (){}
          //   ),
          // ),
        ],
      ),
          
      body: SafeArea(child: 
        SingleChildScrollView(child: 
          Column(children: [

            _drawGraphSlider(),
            const SizedBox(height: 20),


            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                color: Colors.white,
                height: 240,
                child: _barChart()
              ),
            ),


            Padding(
              padding: Constant.pagePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i=1; i<32; i++) 
                    _dateRow('$i'),
                ]
              )
            ),

            const SizedBox(height: 20),


            const Padding(
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('クライアント', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),


            Container(
              // padding: const EdgeInsets.all(20),
              child: Container(
                color: Colors.white,
                height: 240,
                child: _pieChart()
              ),
            ),

            Padding(
              padding: Constant.pagePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i=0; i<_clients.length; i++) 
                    _clientRow(_clients[i]),
                ]
              )
            ),


            const Padding(
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('プロジェクト', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),


            Container(
              // padding: const EdgeInsets.all(20),
              child: Container(
                color: Colors.white,
                height: 240,
                child: _pieChart()
              ),
            ),

            // Container(
            //   padding: const EdgeInsets.all(20),
            //   child: Container(
            //     color: Colors.white,
            //     height: 240,
            //     child: _timeChart()
            //   ),
            // ),

            Padding(
              padding: Constant.pagePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i=0; i<_projects.length; i++) 
                    _projectRow(_projects[i]),
                ]
              )
            )


          ],
        )
      )));
  }


  // Pie Chart
  // generics型を明示しないとエラーが発生するので注意
  // https://github.com/google/charts/issues/651

  Widget _pieChart() {
    return charts.PieChart<Object>(
      _createSampleData3(),
      animate: false,
      
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,

          changedListener: (charts.SelectionModel model) {
            // final selectedDatum = model.selectedDatum;
            // if (selectedDatum.isNotEmpty) {
            //   setState(() {
            //     sales = selectedDatum.first.datum.sales;
            //     year = selectedDatum.first.datum.year;
            //   });
            // }
          }
        )
      ],

      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 80,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.auto,
            insideLabelStyleSpec: const charts.TextStyleSpec(fontSize: 11, color: charts.Color.white),
            outsideLabelStyleSpec: const charts.TextStyleSpec(fontSize: 11, color: charts.Color.black)
          )
        ]
      ),
    );
  }


  // Bar Chart

  final _barChartTooltip = TooltipSymbolRenderer();

  Widget _barChart() {
    return charts.BarChart(
      _createSampleData(),
      animate: true,

      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.selectedDatum.isNotEmpty) {
              _barChartTooltip.value = model.selectedDatum.first.datum.sales.toString();
            }
          }
        )
      ],
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: _barChartTooltip
        )
      ],
    );
  }


  // Line Chart

  final _lineChartTooltip = TooltipSymbolRenderer();

  Widget _timeChart() {
    return charts.TimeSeriesChart(
      _createSampleData2(),
      animate: true,

      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.selectedDatum.isNotEmpty) {
              _lineChartTooltip.value = model.selectedDatum.first.datum.sales.toString();
            }
          }
        )
      ],
      behaviors: [
        charts.LinePointHighlighter(
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
          symbolRenderer: _lineChartTooltip
        )
      ],
    );
  }


  Widget _drawGraphSlider() {
    final day1 = DateTime.now();
    final day2 = DateTime.now();
    
    var style = TextStyle(fontSize: 12);

    return Column(

      children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Filter: ', style: style),

              TextButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text('クライアント', style: style)
                  ],
                ),
                onPressed: (){}
              ),
              TextButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text('プロジェクト', style: style)
                  ],
                ),
                onPressed: (){}
              ),
              TextButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sell_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text('タグ', style: style)
                  ],
                ),
                onPressed: (){}
              ),
          ]),
        ),

        const SizedBox(height: 20),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            const SizedBox(width: 12),
            const Icon(Icons.event_note_outlined, size: 18),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('カスタム', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('今月', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('今週', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('先月', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('先週', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('3ヶ月', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('半年', style: style)),
            const SizedBox(width: 6),
            OutlinedButton(onPressed: () {}, child: Text('1年', style: style)),
            const SizedBox(width: 12),
          ]),
        ),

        const SizedBox(height: 20),

        Column(
          children: [
            Ext.t('${day1.year}年${day1.month}月${day1.day}日 - ${day2.month}月${day2.day}日', size: 14, bold: true),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Ext.t('123', size: 24, bold: true),
                const SizedBox(width: 5),
                Ext.t('時間', size: 14, bold: true),
                const SizedBox(width: 5),
                Ext.t('23', size: 24, bold: true),
                const SizedBox(width: 5),
                Ext.t('分', size: 14, bold: true)
              ]
            )
          ]
        ),


      ]
    );
  }



  Widget _dateRow(String day) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(3),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text('2022/1/$day'),
          ),

          const Text('10.0h'),
          
          // for (var i=0; i<projects.length; i++)
            // _projectRow(projects[i]),
      ])
    );
  }


  Widget _clientRow(Client client) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(3),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(client.name),
          ),

          const Text('10.0h'),

          const SizedBox(
            width: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('50%'),
              )
          )
          
          // for (var i=0; i<projects.length; i++)
            // _projectRow(projects[i]),
      ])
    );
  }

  Widget _projectRow(Project project) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(3),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(project.name),
          ),

          const Text('10.0h'),

          const SizedBox(
            width: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('50%'),
              )
          )
          
          // for (var i=0; i<projects.length; i++)
            // _projectRow(projects[i]),
      ])
    );

/*
    return SizedBox(
      // padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          // backgroundColor: Colors.white,
          padding: const EdgeInsets.all(6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          )
        ),
          
        child: Row(
          children: [
            Expanded(child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [

                    const SizedBox(width: 8),

                    Container(
                      width: 4,
                      height: 4,
                      color: project.color()
                    ),

                    const SizedBox(width: 8),

                    Ext.t(project.name, size: 15),

                    // if (hasClient)
                      // const SizedBox(width: 10),

                    // if (hasClient)
                      // Ext.t(project.client!.name, size: 13),
                  ]
                )
              ])
            ),
        ]),

        onPressed: () => {}
      )
    );
*/
  }

}

