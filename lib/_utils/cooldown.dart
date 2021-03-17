import 'package:flutter/material.dart';

class CoolDown {
  int _lastCallMs = 0;

  CoolDown(this.duration);
  final Duration duration;

  void run(VoidCallback action) {
    if (DateTime.now().millisecondsSinceEpoch - _lastCallMs > duration.inMilliseconds) {
      action.call();
      _lastCallMs = DateTime.now().millisecondsSinceEpoch;
    }
  }
}
