import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Full app', () {
    final styledPageScaffold = find.byValueKey('StyledPageScaffold');
    final authSubmitButton = find.byValueKey('auth_submit_button');

    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('StyledPageScaffold appears after login and scrolls', () async {
      await driver.startTracing(streams: [TimelineStream.embedder]);
      await driver.waitFor(authSubmitButton);
      await driver.tap(authSubmitButton);
      await driver.waitFor(styledPageScaffold);
      for (var i = 0; i < 10; i++) {
        await driver.scroll(
            styledPageScaffold, 0, -6000, const Duration(seconds: 1));
        await driver.tap(styledPageScaffold);
        await driver.scroll(
            styledPageScaffold, 0, 5000, const Duration(seconds: 2));
        await driver.tap(styledPageScaffold);
      }
      final timeline = await driver.stopTracingAndDownloadTimeline();

      final now = DateTime.now();
      final nowString = now.toIso8601String().replaceAll(':', '-');
      final file = File('benchmark/timeline-$nowString.json');
      await file.writeAsString(json.encode(timeline.json));

    }, timeout: Timeout(const Duration(minutes: 3)));
  });
}
