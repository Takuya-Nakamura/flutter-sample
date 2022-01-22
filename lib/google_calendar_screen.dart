import 'package:flutter/material.dart';

import '../util/ext.dart';

//google
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart' as gc;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

//date format
import 'package:intl/intl.dart';

class GoogleCalendarScreen extends StatefulWidget {
  const GoogleCalendarScreen({Key key}) : super(key: key);

  @override
  _GoogleCalendarScreenState createState() => _GoogleCalendarScreenState();
}

class _GoogleCalendarScreenState extends State<GoogleCalendarScreen> {
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  static const _scopes = [gc.CalendarApi.calendarScope]; //全権限
  final clientKey = (Platform.isAndroid)
      ? ''
      : '830112706716-ikipq7dsk27dom9j2rbvgqelri8usu2q.apps.googleusercontent.com';
  var _credentials;
  var _client;
  
  gc.CalendarApi _calendar;
  List<gc.CalendarListEntry> _calendarList = [];

  List<gc.Event> events = [];
  String calendarName = '';
  String currentCalendarId = '';
  String currentCalendarSummary = '';

  String currentEventId = '';
  String currentEventSummary = '';
  String addEventSummray = '';
  String newEventSummary = '';

  @override
  void initState() {
    _credentials = ClientId(clientKey, '');
  }

  //*****************************
  // 認証実行
  //*****************************
  _onPressGetClient() async {
    clientViaUserConsent(_credentials, _scopes, _prompt)
        .then((AuthClient client) {
      setState(() {
        _client = client;
        _calendar = gc.CalendarApi(client);
      });
      closeWebView();
    });
  }

  /// 認証時ブラウザ表示
  _prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //*****************************
  // カレンダー取得
  //*****************************
  _onPressGetCalendar() async {
    if (_calendar != null) {
      _calendar.calendarList.list().then((value) => {
            setState(() {
              _calendarList = value.items;
            })
          });
    }
  }

  //*****************************
  // カレンダー追加
  //*****************************
  _onPressAddCalendar() async {
    if (calendarName != '') {
      _calendar.calendars
          .insert(gc.Calendar(summary: calendarName))
          .then((value) {
        setState(() {
          calendarName = '';
        });
        _onPressGetCalendar();
      });
    }
  }

  //*****************************
  // イベント取得
  //*****************************
  _onPressGet() async {
    try {
      final now = DateTime.now();
      final start = now.subtract(Duration(days: 60));
      final end = now.add(Duration(days: 15));

      // String calendarId = "primary";
      String calendarId = currentCalendarId;

      _calendar.events
          .list(calendarId, timeMin: start, timeMax: end)
          .then((value) {
        closeWebView();
        setState(() {
          events = value.items.whereType<gc.Event>().toList();
        });
      });
    } catch (e) {
      print('Add Error $e');
    }
  }

  _onPressEvent(id, summary) {
    setState(() {
      currentEventId = id;
      currentEventSummary = summary;
    });
  }

  //*****************************
  // イベント追加
  //*****************************
  _onPressAdd() async {
    final now = DateTime.now();
    //イベント登録作成
    gc.Event event = gc.Event();
    event.summary = addEventSummray;

    gc.EventDateTime start = gc.EventDateTime();
    start.dateTime = now;
    start.timeZone = "GMT+09:00";
    event.start = start;

    gc.EventDateTime end = gc.EventDateTime();
    end.timeZone = "GMT+09:00";
    end.dateTime = now.add(Duration(days: 1));
    event.end = end;

    _addEvent(event);
  }

  _addEvent(event) {
    try {
      String calendarId = currentCalendarId;
      _calendar.events.insert(event, calendarId).then((value) {
        _onPressGet();
      });
    } catch (e) {
      print('Add Error $e');
    }
  }

  //*****************************
  // イベント編集
  //*****************************
  _onPressEdit() {
    print('_onPressEdit');

    _calendar.events.get(currentCalendarId, currentEventId).then((event) {
      event.summary = newEventSummary;
      _calendar.events
          .update(event, currentCalendarId, currentEventId)
          .then((value) {
        print('update_cmp');
        _onPressGet();
      });
    });
  }

  //*****************************
  // イベント削除
  //*****************************
  _onPressDelete() {
    _calendar.events.delete(currentCalendarId, currentEventId).then((value) {
      print('deleted');
      _onPressGet();
    });
  }
  //*****************************
  // build
  //*****************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Google Calendar'),
            leading: Ext.navibarClose(context)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
          child: Column(
            children: [
              spacer(40),
              exportButton('認証 client 取得', _onPressGetClient),
              clientWidget(),
              spacer(40),
              exportButton('カレンダー取得', _onPressGetCalendar),
              Column(
                children: calendarListWidget(),
              ),
              spacer(40),
              Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: calendarName,
                    decoration: const InputDecoration(
                      hintText: '新規カレンダー名',
                    ),
                    onChanged: (text) {
                      setState(() {
                        calendarName = text;
                      });
                    },
                  )),
              exportButton('カレンダー追加', _onPressAddCalendar),
              spacer(40),
              currentCalendarWidget(),
              spacer(40),
              exportButton('イベント取得', _onPressGet),
              Column(
                children: eventsList(),
              ),
              currentEventWidget(),
              spacer(40),
              Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: calendarName,
                    decoration: const InputDecoration(
                      hintText: '追加するイベント名',
                    ),
                    onChanged: (text) {
                      setState(() {
                        addEventSummray = text;
                      });
                    },
                  )),
              spacer(40),
              exportButton('イベント追加', _onPressAdd),
              spacer(40),
              exportButton('イベント削除', _onPressDelete),
              spacer(40),
              Container(
                  width: 300,
                  child: TextFormField(
                    initialValue: calendarName,
                    decoration: const InputDecoration(
                      hintText: '新規イベント名',
                    ),
                    onChanged: (text) {
                      setState(() {
                        newEventSummary = text;
                      });
                    },
                  )),
              exportButton('イベント編集', _onPressEdit),
              spacer(40),
            ],
          ),
        ))));
  }

  Widget clientWidget() {
    final text = _client != null ? '認証済み' : '未認証';
    return Column(
      children: [
        Text('認証状態: ${text}'),
      ],
    );
  }

  _onPressCalendar(id, summary) {
    setState(() {
      currentCalendarId = id;
      currentCalendarSummary = summary;
    });
  }

  //*************
  // calendar widget
  //*************
  List<Widget> calendarListWidget() {
    List<Widget> response = [];
    if (_calendarList != null) {
      _calendarList.forEach((cal) {
        final text = '${cal.summary} (desc: ${cal.description}) ${cal.id}';
        response.add(listButton(text, () {
          _onPressCalendar(cal.id, cal.summary);
        }));
        response.add(spacer(10));
      });
      return response;
    } else {
      return [];
    }
  }

  Widget currentCalendarWidget() {
    final text = currentCalendarId == '' ? '未選択' : currentCalendarSummary;
    return Text('現在のカレンダー:' + text);
  }

  //*************
  // event widget
  //*************
  List<Widget> eventsList() {
    List<Widget> response = [];
    events.forEach((event) {
      if (event.start != null) {
        var startPre = event.start?.dateTime;
        final start = outputFormat.format(startPre);
        final text = '${start} : ${event.summary}';
        response.add(listButton(text, () {
          _onPressEvent(event.id, event.summary);
        }));
      }
    });
    return response;
  }

  Widget currentEventWidget() {
    final text = currentEventId == '' ? '未選択' : currentEventSummary;
    return Text('現在のイベント:' + text);
  }

  //*************
  // Button
  //*************
  Widget exportButton(text, onPress) {
    return SizedBox(
        width: 200,
        // height: 100,
        child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: const RoundedRectangleBorder()),
            child: Text(text),
            onPressed: onPress));
  }

  Widget listButton(text, onPress) {
    return SizedBox(
        width: 300,
        // height: 100,
        child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: onPress));
  }

  Widget spacer(double height) {
    return SizedBox(
      height: height,
    );
  }
}
