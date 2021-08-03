import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import '../../_utils/device_info.dart';
import '../commands.dart';

class SaveWindowSizeCommand extends BaseAppCommand {
  Future<void> run() async {
    // Only save window size to disk on desktop platforms.
    if (DeviceOS.isDesktop) {
      Size size = await DesktopWindow.getWindowSize();
      if (size != appModel.windowSize) {
        appModel.windowSize = size;
        appModel.scheduleSave();
      }
    }
  }
}
