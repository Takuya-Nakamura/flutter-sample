import 'package:flutter/material.dart';
import 'client.dart';

class Project {

  Client client;

  int id = 0;
  String name;
  String hexColor;
  bool selected = false;

  Project({
    this.name,
    this.hexColor
  });

  Color color() {
    return Color(int.parse(hexColor, radix: 16));
  }

  void setHexColor(Color color) {
    hexColor = color.value.toRadixString(16);
  }
}
