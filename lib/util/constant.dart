import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Constant {

  // Size
  static const double navibarTitle = 18;
  static const double navibarTitleSmall = 16;

  // Color
  static const Color cBackground = Color(0xFFecf0f3);
  static const Color cNavibar = Color(0xFF0D63FE);
  static const Color cText = Color(0xFF333333);

  // Page
  static const pagePadding = EdgeInsets.all(16);

  // デバッグモード判定
  // https://blog.dalt.me/2513
  static bool isDebug() {
    return kDebugMode;
  }
}


class ConstantForm {

  static const fontSize = 15.0;

  static const placeholderColor = Colors.grey;

  static const height = 44.0;
  static const radius = BorderRadius.all(Radius.circular(8));

}