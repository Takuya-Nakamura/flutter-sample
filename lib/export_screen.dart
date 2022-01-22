import 'package:flutter/material.dart';

import '../util/ext.dart';
import '../util/constant.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

//CSV
class _ExportScreenState extends State<ExportScreen> {
  _onPressCsvExport() async {
    final csv = const ListToCsvConverter().convert(
      [
        ['id', 'name', 'score'],
        ['1', 'name1,', 40],
        ['2', 'name2 "', 42],
        ['3', 'name  3', "45"],
      ],
      // delimitAllFields: true,
      // fieldDelimiter: '\t'
    );
    final filePath = await _localPath('test.csv');
    await File(filePath).writeAsString(csv);
  }

  //Excel
  _onPressExcelExport() async {
    //テンプレート利用
    //https://stackoverflow.com/questions/55921063/flutter-excel-sheet-in-the-assets-folder
    ByteData data = await rootBundle.load("resources/report/template.xlsx");
    List<int> tempBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final Excel excel = Excel.decodeBytes(tempBytes);

    //新規作成
    // final Excel excel = Excel.createExcel();

    _inputCell(excel['シート1']);
    _inputCell(excel['シート2']);
    excel.delete('Sheet1'); //defaultSheetを削除
    final List<int> bytes = excel.encode();

    if (bytes != null) {
      final filePath = await _localPath('test.xlsx');
      print(filePath);
      await File(filePath).writeAsBytes(bytes);
    }
  }

  _inputCell(sheet) {
    for (var i = 0; i < 30; i++) {
      for (var j = 0; j < 10; j++) {
        final Data cell =
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
        cell.value = i;
      }
    }
  }

  //PDF
  _onPressPdfExport() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              // child: pw.Text("Hello World"),
              child: pw.Column(
            children: [_pdfUndeLineText(), _pdfTableWidget()],
          )); // Center
        }));
    final filePath = await _localPath('test.pdf');
    await File(filePath).writeAsBytes(await pdf.save());
  }

  _pdfTableWidget() {
    return pw.Table.fromTextArray(data: const <List<String>>[
      <String>['Date', 'PDF Version', 'Acrobat Version'],
      <String>['1993', 'PDF 1.0', 'Acrobat 1'],
      <String>['1994', 'PDF 1.1', 'Acrobat 2'],
      <String>['1996', 'PDF 1.2', 'Acrobat 3'],
      <String>['1999', 'PDF 1.3', 'Acrobat 4'],
      <String>['2001', 'PDF 1.4', 'Acrobat 5'],
      <String>['2003', 'PDF 1.5', 'Acrobat 6'],
      <String>['2005', 'PDF 1.6', 'Acrobat 7'],
      <String>['2006', 'PDF 1.7', 'Acrobat 8'],
      <String>['2008', 'PDF 1.7', 'Acrobat 9'],
      <String>['2009', 'PDF 1.7', 'Acrobat 9.1'],
      <String>['2010', 'PDF 1.7', 'Acrobat X'],
      <String>['2012', 'PDF 1.7', 'Acrobat XI'],
      <String>['2017', 'PDF 2.0', 'Acrobat DC'],
    ]);
  }

  _pdfUndeLineText() {
    return pw.Column(children: [
      pw.Text(
        'THIS ACKNOWLEDGES THAT',
        style: const pw.TextStyle(
          fontSize: 10,
          letterSpacing: 2,
          wordSpacing: 2,
        ),
      ),
      pw.SizedBox(
        width: 300,
        child: pw.Divider(color: PdfColors.grey, thickness: 1),
      ),
      pw.Text(
        'Sample Text',
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 20,
        ),
      ),
      pw.SizedBox(
        width: 300,
        child: pw.Divider(color: PdfColors.grey, thickness: 1),
      ),
    ]);
  }

  Future<String> _localPath(filepath) async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + '/' + filepath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('エクスポート'), leading: Ext.navibarClose(context)),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              exportButton('CSV保存', _onPressCsvExport),
              const SizedBox(
                height: 40,
              ),
              exportButton('Excel保存', _onPressExcelExport),
              const SizedBox(
                height: 40,
              ),
              exportButton('PDF保存', _onPressPdfExport),
            ],
          ),
        )));
  }

  Widget exportButton(text, onPress) {
    return SizedBox(
        width: 200,
        // height: 100,
        child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: ConstantForm.radius)),
            child: Text(text),
            onPressed: onPress));
  }
}
