import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

import './constant.dart';



class Ext {

  // Text Widget
  static Widget t(String text, { 
    double size = 13,
    bool bold = false, 
    Color color = Constant.cText,
    TextAlign align = TextAlign.left,
    int maxLines = 99
  }) {
    return Text(text,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        color: color
      )
    );
  }

  static asset(String name, { String suffix = '.png' }) {
    return AssetImage('resources/assets/$name$suffix');
  }


  // ナビバーの閉じるボタン
  static Widget navibarClose(BuildContext context) {
    return TextButton(
      child: const Icon(Icons.close, color: Colors.white),
      onPressed: (){ Navigator.pop(context); }
    );
  }

  // Alert表示
  static void alert(BuildContext context, String title, String message, List<Widget> actions, { int orientation = 0 }) {
    showDialog(
      context: context,
      builder: (_) {
        return  RotatedBox(
          quarterTurns: orientation,
          child:AlertDialog(
          title: Ext.t(title, size: 18, bold: true),
          content: Ext.t(message, size: 15),
          actions: actions
        ));
      }
    );
  }

  static Future<bool> showNetworkAlertIfNeeded(BuildContext context) async {
    // if (await Ext.isNetworkReachable()) {
    //   return false;
    // }
     Ext.alert(context, 'エラー', 'インターネットに接続可能かご確認ください。', [
      TextButton(
        child: Ext.t('閉じる', size: 15, color: Colors.blue),
        onPressed: () => Navigator.pop(context),
      )
    ]);
    return true;
  }

  // static Future<bool> isNetworkReachable() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   return connectivityResult != ConnectivityResult.none;
  // }
}
