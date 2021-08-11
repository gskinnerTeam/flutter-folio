import 'package:flutter/material.dart';

import 'window_utils.dart';

IoUtils _instance = IoUtilsNoOp();
IoUtils getInstance() => _instance;

class IoUtilsNoOp implements IoUtils {
  @override
  void showWindowWhenReady() {}
  @override
  Widget wrapNativeTitleBarIfRequired(Widget child) => child;
  void setMinSize(Size size) {}

  @override
  void setTitle(String title) {}
}
