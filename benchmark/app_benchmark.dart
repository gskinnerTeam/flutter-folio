import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Full app', () {
    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test(
      'homepage scrolling up and down',
      () async {
        await _ensureLoggedIn(driver);

        await driver.startTracing(streams: [TimelineStream.embedder]);
        for (var i = 0; i < 10; i++) {
          // Scroll about 6 pages down ...
          await driver.scroll(
              styledPageScaffold, 0, -6000, const Duration(seconds: 1));
          await driver.tap(styledPageScaffold);
          // ... and about 5 pages up.
          await driver.scroll(
              styledPageScaffold, 0, 5000, const Duration(seconds: 2));
          await driver.tap(styledPageScaffold);
        }
        final timeline = await driver.stopTracingAndDownloadTimeline();
        await _saveTimeline('homepage-scrolling', timeline);
      },
      timeout: _increasedTimeout,
      skip: 'currently only have one folio, so no scrolling',
    );

    test('going from login screen to homepage and back', () async {
      await _ensureLoggedIn(driver);

      await driver.startTracing(streams: [TimelineStream.embedder]);
      for (var i = 0; i < 50; i++) {
        // Log out ...
        await driver.tap(roundedProfileButton);
        await driver.tap(logoutButton);
        // ... then log in again.
        await driver.tap(authSubmitButton);
      }
      final timeline = await driver.stopTracingAndDownloadTimeline();

      await _saveTimeline('login-to-homepage', timeline);
    }, timeout: _increasedTimeout);

    test('opening and closing the "create new" sheet', () async {
      await _ensureLoggedIn(driver);

      await driver.startTracing(streams: [TimelineStream.embedder]);
      for (var i = 0; i < 50; i++) {
        // Open ...
        await driver.tap(newFolioFab);
        // ... and close.
        await driver.scroll(
            newFolioCard, 0, 5000, const Duration(milliseconds: 200));
      }
      final timeline = await driver.stopTracingAndDownloadTimeline();

      await _saveTimeline('create-new-sheet', timeline);
    }, timeout: _increasedTimeout);
  });
}

final authSubmitButton = find.byValueKey('auth_submit_button');
final logoutButton = find.byValueKey('logout_button');
final materialApp = find.byType('MaterialApp');
final newFolioFab = find.byType('_NewFolioFab');
final newFolioCard = find.byType('_NewFolioCard');
final roundedProfileButton = find.byValueKey('rounded_profile_button');
final styledPageScaffold = find.byValueKey('StyledPageScaffold');

final Timeout _increasedTimeout = Timeout(const Duration(minutes: 5));

Future<void> _ensureLoggedIn(FlutterDriver driver) async {
  // await driver.waitFor(find.byType('MainAppScaffold'));

  // XXX: The following currently always returns an empty string.
  //      We basically have no way of programmatically learning if we're
  //      logged in or out.
  // final renderTree = await driver.getRenderTree();
  // print('render tree:');
  // print(renderTree.tree);

  if (false) {
    await driver.tap(authSubmitButton);
  }
}

Future<void> _saveTimeline(String label, Timeline timeline) async {
  final now = DateTime.now();
  final nowString = now.toIso8601String().replaceAll(':', '-');
  final file = File('benchmark/$label-$nowString.json');
  await file.writeAsString(json.encode(timeline.json));
}
