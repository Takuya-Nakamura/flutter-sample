import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  String _text = '';

  void _handleChange(String newValue) {
    setState(() {
      _text = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      // onSelected: _handleChange,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "1",
          child: Text('選択1'),
        ),
        const PopupMenuItem<String>(
          value: "2",
          child: Text('選択2'),
        ),
        const PopupMenuItem<String>(
          value: "3",
          child: Text('選択3'),
        ),
        const PopupMenuItem<String>(
          value: "4",
          child: Text('選択4'),
        ),
      ],
    );
  }
}
