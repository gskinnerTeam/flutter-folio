import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/native_window_utils/titlebar_wrappers/macos_title_bar.dart';
import 'package:flutter_folio/_utils/native_window_utils/titlebar_wrappers/windows_title_bar.dart';
import 'package:flutter_folio/_utils/native_window_utils/titlebar_wrappers/linux_title_bar.dart';
import 'package:flutter_folio/_utils/native_window_utils/window_utils.dart';

IoUtils _instance = IoUtilsNative();
IoUtils getInstance() => _instance;

class IoUtilsNative implements IoUtils {
  IoUtilsNative() {}

  void showWindowWhenReady() {
    if (Platform.isWindows == false) return;
    doWhenWindowReady(() {
      // Apply min-window size, allow a smaller size when developing for easier responsive testing.
      appWindow.minSize = kReleaseMode ? Size(800, 600) : Size(300, 400);
      appWindow.show();
    });
  }

  Widget wrapNativeTitleBarIfRequired(Widget child) {
    if (Platform.isWindows) {
      return WindowsTitleBar(child);
    } else if (Platform.isLinux) {
      return LinuxTitleBar(child);
    } else if (Platform.isMacOS) {
      return MacosTitleBar(child);
    }
    return child;
  }
}
