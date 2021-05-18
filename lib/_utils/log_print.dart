import 'dart:async';

import 'package:flutter/material.dart';

void Function(String value)? onPrint;
String logHistory = "";

class PrintLogger {}

void log(String? value) {
  String v = value ?? "";
  //if (kReleaseMode) return;
  logHistory = v + "\n" + logHistory;
  onPrint?.call(v);
}

void logError(String? value) => log("[ERROR] " + (value ?? ""));

// Take from: https://flutter.dev/docs/testing/errors
void initErrorLogger(VoidCallback runApp) {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      logError(details.stack.toString());
    };
    runApp.call();
  }, (Object error, StackTrace stack) {
    logError(stack.toString());
  });
}
