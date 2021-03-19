import 'dart:math';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/native_window_utils/window_utils.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/app/refresh_menubar_command.dart';
import 'package:flutter_folio/commands/books/refresh_all_books_command.dart';
import 'package:flutter_folio/commands/commands.dart' as Commands;
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:system_info/system_info.dart';

import 'set_current_user_command.dart';

class BootstrapCommand extends Commands.BaseAppCommand {
  static int kMinBootstrapTimeMs = 2000;

  Future<void> run(BuildContext context) async {
    int startTime = TimeUtils.nowMillis;
    if (Commands.hasContext == false) {
      Commands.setContext(context);
    }
    print("Bootstrap Started, v${AppModel.kVersion}");
    // Load AppModel ASAP
    await appModel.load();
    safePrint("BootstrapCommand - AppModel Loaded, user = ${appModel.currentUser}");
    if (firebase.isSignedIn == false && appModel.currentUser != null) {
      // If we previously has a user, it's unexpected that firebase has lost auth. Give it some extra time.
      await Future<void>.delayed(Duration(seconds: 1));
      // See if we don't have auth now...
      if (firebase.isSignedIn == false) {
        //Still no auth, clear the stale user data. // TODO: Can we try some sort of re-auth here instead of just bailing
        appModel.currentUser = null;
      }
    }
    // Init services
    cloudStorage.init();
    // Set the cacheSize so we'll use more RAM on desktop and higher spec devices.
    _configureMemoryCache();

    // Once model is loaded, we can configure the desktop.
    if (DeviceOS.isDesktop) {
      _configureDesktop();
    }
    // Login?
    if (appModel.currentUser != null) {
      await SetCurrentUserCommand().run(appModel.currentUser);
      await RefreshAllBooks();
    }
    // For aesthetics, we'll keep splash screen up for some min-time (skip on web)
    if (kIsWeb == false) {
      int remaining = kMinBootstrapTimeMs - (TimeUtils.nowMillis - startTime);
      if (remaining > 0) {
        await Future<void>.delayed(Duration(milliseconds: remaining));
      }
    }
    appModel.hasBootstrapped = true;
    safePrint("BootstrapCommand - Complete");
  }

  void _configureMemoryCache() {
    // Use more memory by default on desktop
    int cacheSize = (DeviceOS.isDesktop ? 2048 : 512) << 20;
    // If we're on a native platform, reserve some reasonable amt of RAM
    if (DeviceOS.isDesktop) {
      try {
        // Use some percentage of system ram, but don't fall below the default, in case this returns 0 or some other invalid value.
        cacheSize = max(cacheSize, (SysInfo.getTotalPhysicalMemory() / 4).round());
      } on Exception catch (e) {
        safePrint(e.toString());
      }
    }
    imageCache?.maximumSizeBytes = cacheSize;
  }

  void _configureDesktop() {
    // /// Polish (for Windows OS), to hide any movement of the window on startup.
    IoUtils.instance.showWindowWhenReady();
    IoUtils.instance.setTitle("Flutter Folio");
    Size minSize = Size(600, 700);
    if (kDebugMode) minSize = Size(400, 400);
    DesktopWindow.setMinWindowSize(minSize);
    if (appModel.windowSize.shortestSide > 0) {
      DesktopWindow.setWindowSize(appModel.windowSize);
    }
    // Update the native fileMenu to the initial values
    RefreshMenuBarCommand().run();
  }
}
