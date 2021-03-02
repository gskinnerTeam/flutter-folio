import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_size/window_size.dart';

class SaveWindowSizeCommand extends BaseAppCommand {
  Future<void> run() async {
    if (UniversalPlatform.isLinux || UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      Rect rect = (await getWindowInfo()).frame;
      if (rect != appModel.windowRect) {
        appModel.windowRect = rect;
        appModel.scheduleSave();
      }
    }
  }
}
