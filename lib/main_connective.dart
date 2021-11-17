import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Widget
class ConnectiveSamplePage extends StatefulWidget {
  @override
  _ConnectiveSamplePage createState() => _ConnectiveSamplePage();
}

class _ConnectiveSamplePage extends State<ConnectiveSamplePage> {
  //debug
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    _initConnectivity();

    super.initState();
  }

  void _initConnectivity() async {
    connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      connectivityResult = connectivityResult;
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'オフラインチェック',
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min, //columnを上下中央に配置するために必要
      children: [
        Text("接続状態"),
        Text(connectivityResult.toString()),
      ],
    ));
  }
}
