// @dart=2.12
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:desktop_window/desktop_window.dart';

class SaveWindowSizeCommand extends BaseAppCommand {
  Future<void> run() async {
    if (UniversalPlatform.isLinux || UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      Size size = await DesktopWindow.getWindowSize();
      if (size != appModel.windowSize) {
        appModel.windowSize = size;
        appModel.scheduleSave();
      }
    }
  }
}
