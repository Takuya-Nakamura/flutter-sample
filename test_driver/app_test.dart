import 'package:flutter_driver/flutter_driver.dart';

import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('WebView Test', () {

    final openPageFinder = find.byValueKey('openPage');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    Future<void> takeScreenshot(FlutterDriver driver, String path) async {
      print('will take screenshot $path');
      // スクリーンショットを撮る前など、アプリケーションが「安定」するまでを待つ必要がある時に使うコールバックメソッド
      await driver.waitUntilNoTransientCallbacks();
      final pixels = await driver.screenshot();
      final file = File(path);
      await file.writeAsBytes(pixels);
      print('wrote $file');
    }

    test('check flutter driver extension', () async {
      final health = await driver.checkHealth();
      print(health.status);
    });

    test('Shown WebView Screen', () async {

      // await driver.tap(openPageFinder);
      // 保存先のパスをパラメーターとして渡します。
      await takeScreenshot(driver, './test_driver/screenshots/web_view.png');
    });
  });
}