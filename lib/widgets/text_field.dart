import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  //props
  final String name;
  final Function onChanged;

  //constructor
  MyTextField({this.name, this.onChanged});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  //private

  void _handleChangeText(text) {
    print("_handleChangeText");
    print(text);
    widget.onChanged(text); //widgetでpropsを利用
  }

  Widget build(BuildContext context) {
    return TextField(
      onChanged: _handleChangeText,
      decoration: InputDecoration(hintText: '名前'),
    );
  }
}
