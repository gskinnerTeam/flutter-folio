import 'dart:math';

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
import 'package:window_size/window_size.dart';

import 'set_current_user_command.dart';

class BootstrapCommand extends Commands.BaseAppCommand {
  static int kMinBootstrapTimeMs = 2000;

  Future<void> run(BuildContext context) async {
    int startTime = TimeUtils.nowMillis;
    if (Commands.mainContext == null) {
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
    if (DeviceInfo.isDesktop) {
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
    int cacheSize = (DeviceInfo.isDesktop ? 2048 : 512) << 20;
    // If we're on a native platform, reserve some reasonable amt of RAM
    if (kIsWeb == false) {
      try {
        // Use some percentage of system ram, but don't fall below the default, in case this returns 0 or some other invalid value.
        cacheSize = max(cacheSize, (SysInfo.getTotalPhysicalMemory() / 4).round());
      } on Exception catch (e) {
        print(e);
      }
    }
    imageCache.maximumSizeBytes = cacheSize;
  }

  void _configureDesktop() {
    // /// Polish (for Windows OS), to hide any movement of the window on startup.
    IoUtils.instance.showWindowWhenReady();

    setWindowTitle("Flutter Folio");
    Size minSize = Size(600, 700);
    setWindowMinSize(minSize);
    setWindowMaxSize(Size(8192, 8192)); // maxSize is needed for Linux to allow scaling, TODO: log an issue for this

    // Restore the previous window settings on load
    if (appModel.hasValidWindowRect) {
      setWindowFrame(appModel.windowRect);
      safePrint("Restoring window with frame: ${appModel.windowRect}");
    } else {
      setWindowFrame(Rect.fromLTRB(50, 50, 800, 700));
    }

    // Update the native fileMenu to the initial values
    RefreshMenuBarCommand().run();
  }
}
