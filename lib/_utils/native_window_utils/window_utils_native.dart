import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../device_info.dart';
import 'titlebar_wrappers/linux_title_bar.dart';
import 'titlebar_wrappers/macos_title_bar.dart';
import 'titlebar_wrappers/windows_title_bar.dart';
import 'window_utils.dart';

IoUtils _instance = IoUtilsNative();
IoUtils getInstance() => _instance;

class IoUtilsNative implements IoUtils {
  IoUtilsNative();

  @override
  void showWindowWhenReady() {
    if (Platform.isWindows == false) return;
    doWhenWindowReady(() {
      // Apply min-window size, allow a smaller size when developing for easier responsive testing.
      appWindow.minSize = kReleaseMode ? const Size(800, 600) : const Size(300, 400);
      appWindow.show();
    });
  }

  @override
  Widget wrapNativeTitleBarIfRequired(Widget child) {
    if (DeviceOS.isWindows) {
      return WindowsTitleBar(child);
    } else if (DeviceOS.isLinux) {
      return LinuxTitleBar(child);
    } else if (DeviceOS.isMacOS) {
      return MacosTitleBar(child);
    }
    return child;
  }

  @override
  void setTitle(String title) {
    appWindow.title = title;
  }
}
