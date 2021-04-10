import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class InputUtils {
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
  }

  static bool get isMouseConnected => RendererBinding.instance?.mouseTracker.mouseIsConnected ?? false;

  static void unFocus() {
    primaryFocus?.unfocus();
  }
}
