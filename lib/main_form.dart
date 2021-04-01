import 'package:flutter/material.dart';
import 'widgets/dropdown.dart';
import 'widgets/pouup_menu.dart';
import 'widgets/click_good.dart';
import 'widgets/text_field.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(FormSamplePage()); // flutter runAppがウイジェット（コンポーネント）を画面表示する命令
}

class FormSamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful',
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
          title: Text('Form Samples Screen'),
        ),
        body: Center(
          child: FormSample(),
        ),
      ),
    );
  }
}

// Widget
class FormSample extends StatefulWidget {
  @override
  _FormSampleState createState() => _FormSampleState();
}

class _FormSampleState extends State<FormSample> {
  //state
  String name = '';
  String fruits = 'りんご';
  String selected = '';

  _onChangedName(text) {
    print("_onChangedName");
    setState(() {
      name = text;
    });
  }

  _onCangeFruit(text) {
    setState(() {
      fruits = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        FormTextRow(label: '名前', value: name),
        FormTextRow(label: '果物', value: fruits),
        MyTextField(
          name: name,
          onChanged: _onChangedName,
        ),
        DropDown(
          selected: fruits,
          onChanged: _onCangeFruit,
        ),
        // PopUp(),
        ClickGood(),
      ],
    ));
  }
}

//stateless
class FormTextRow extends StatelessWidget {
  final String label;
  final String value;

  FormTextRow({this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text(label, style: TextStyle(color: Colors.white))),
            Container(width: 100, child: Text(value)),
          ]),
    );
  }
}
