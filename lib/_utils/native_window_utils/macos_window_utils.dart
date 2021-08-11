import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

class MacosWindowUtils {
  static const methodChannel = MethodChannel("flutterfolio.com/io");
  static const kMinTitlebarHeight = 24.0;
  static const kDefaultTitlebarHeight = 24.0;
  static double _calculatedTitlebarHeight = 0.0;

  static Future<double> requestTitlebarHeight() async {
    if (Platform.isMacOS == false) return kDefaultTitlebarHeight;
    if (_calculatedTitlebarHeight > 0.0) {
      return _calculatedTitlebarHeight;
    }
    try {
      final double h = await methodChannel.invokeMethod("getTitlebarHeight") as double;
      _calculatedTitlebarHeight = max(h, kMinTitlebarHeight);
    } catch (e) {
      print("MethodChannel error: $e");
      _calculatedTitlebarHeight = kDefaultTitlebarHeight;
    }
    return _calculatedTitlebarHeight;
  }

  static void zoom() async {
    if (Platform.isMacOS == false) return;
    try {
      await methodChannel.invokeMethod("zoom");
    } catch (e) {
      print("MethodChannel error: $e");
    }
  }
}
