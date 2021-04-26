import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin RawKeyboardListenerMixin<T extends StatefulWidget> on State<T> {
  // Must be provided by implementing class
  bool get enableKeyListener;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void handleKeyUp(RawKeyUpEvent value) {}

  void handleKeyDown(RawKeyDownEvent value) {}

  void _handleKey(RawKeyEvent value) {
    if (enableKeyListener == false) return;
    if (value is RawKeyDownEvent) handleKeyDown(value);
    if (value is RawKeyUpEvent) handleKeyUp(value);
  }
}
