import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  //props
  final String selected;
  final Function onChanged;
  DropDown({this.selected, this.onChanged});

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _defaultValue = 'りんご';
  List<String> _list = <String>['りんご', 'オレンジ', 'みかん', 'ぶどう'];

  @override
  Widget build(BuildContext context) {
    // void _handleChange(String newValue) {
    //   setState(() {
    //     _defaultValue = newValue;
    //   });
    // }

    print(_defaultValue);
    return DropdownButton<String>(
      value: widget.selected != null ? widget.selected : _defaultValue,
      // value: _defaultValue,
      onChanged: widget.onChanged,
      items: _list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
