import 'package:flutter/material.dart';

class ContextUtils {
  // Utility methods to get the size/pos of our render boxes in global & local space
  static Size getSize(BuildContext c) {
    try {
      RenderBox? rb = c.findRenderObject() as RenderBox?;
      return rb?.size ?? Size.zero;
    } catch (e) {
      print(e);
    }
    return const Size(1, 1);
  }

  static Offset localToGlobal(BuildContext c, {Offset local = Offset.zero}) {
    try {
      return (c.findRenderObject() as RenderBox?)?.localToGlobal(local) ?? Offset.zero;
    } catch (e) {
      //print(e);
    }
    return Offset.zero;
  }

  static Offset globalToLocal(BuildContext c, Offset global) {
    try {
      return (c.findRenderObject() as RenderBox?)?.globalToLocal(global) ?? Offset.zero;
    } catch (e) {
      //print(e);
    }
    return Offset.zero;
  }
}
