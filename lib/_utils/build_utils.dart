import 'package:flutter/material.dart';

class BuildUtils {
  static void getFutureSizeFromGlobalKey(GlobalKey key, void Function(Size size) callback) {
    Future.microtask(() {
      Size? size = getSizeFromContext(key.currentContext);
      if (size != null) {
        callback(size);
      }
    });
  }

  static Size? getSizeFromContext(BuildContext? context) {
    if (context == null) return null;
    RenderBox? rb = context.findRenderObject() as RenderBox?;
    return rb?.size;
  }

  static Offset? getOffsetFromContext(BuildContext? context, [Offset offset = Offset.zero]) {
    if (context == null) return null;
    RenderBox? rb = context.findRenderObject() as RenderBox?;
    return rb?.localToGlobal(offset);
  }
}
