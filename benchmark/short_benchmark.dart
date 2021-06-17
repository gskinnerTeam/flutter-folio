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
      'short benchmark',
      () async {
        await driver.startTracing(streams: [TimelineStream.embedder]);
        await _ensureLoggedIn(driver);
        // Scroll about 6 pages down ...
        await driver.scroll(
            styledPageScaffold, 0, -6000, const Duration(seconds: 1));
        await driver.tap(styledPageScaffold);
        final timeline = await driver.stopTracingAndDownloadTimeline();
        await _saveTimeline('quick-scroll', timeline);
      },
    );
  });
}

final authSubmitButton = find.byValueKey('auth_submit_button');
final logoutButton = find.byValueKey('logout_button');
final materialApp = find.byType('MaterialApp');
final newFolioCard = find.byType('_NewFolioCard');
final newFolioFab = find.byType('_NewFolioFab');
final roundedProfileButton = find.byValueKey('rounded_profile_button');
final styledPageScaffold = find.byValueKey('StyledPageScaffold');

Future<void> _ensureLoggedIn(FlutterDriver driver) async {
  // XXX: The following currently always returns an empty string.
  //      We basically have no way of programmatically learning if we're
  //      logged in or out.
  // final renderTree = await driver.getRenderTree();
  // print('render tree:');
  // print(renderTree.tree);

  await driver.tap(authSubmitButton);
}

Future<void> _saveTimeline(String label, Timeline timeline) async {
  final now = DateTime.now();
  final nowString = now.toIso8601String().replaceAll(':', '-');
  final file = File('benchmark/$label-$nowString.json');
  await file.writeAsString(json.encode(timeline.json));
}
