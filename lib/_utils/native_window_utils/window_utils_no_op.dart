import 'package:flutter/material.dart';

import 'window_utils.dart';

IoUtils _instance = IoUtilsNoOp();
IoUtils getInstance() => _instance;

class IoUtilsNoOp implements IoUtils {
  void showWindowWhenReady() {}
  Widget wrapNativeTitleBarIfRequired(Widget child) => child;
  void setMinSize(Size size) {}

  @override
  void setTitle(String title) {}
}
