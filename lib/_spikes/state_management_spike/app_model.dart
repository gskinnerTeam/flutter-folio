import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/themes.dart';
import 'package:universal_platform/universal_platform.dart';

import 'main_app_context.dart';

class AppModel_ extends EasyNotifier {
  AppModel_(this.appContext);
  MainAppContext appContext;

  /// Current User
  AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  set currentUser(AppUser currentUser) => notify(() => _currentUser = currentUser);
  bool get isLoggedIn => currentUser != null;

  /// Theme
  AppTheme _theme = AppTheme.fromType(ThemeType.Orange_Light);
  AppTheme get theme => _theme;
  set theme(AppTheme theme) => notify(() => _theme = theme);

  /// Text Direction
  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) => notify(() => _textDirection = value);

  /// Window Size
  Rect _windowRect = Rect.zero;
  Rect get windowRect => _windowRect;
  set windowRect(Rect value) => notify(() => _windowRect = value);

  bool get hasValidWindowRect {
    return !windowRect.isEmpty &&
        windowRect.size.width > 0 &&
        windowRect.size.height > 0 &&
        windowRect.left > 0 &&
        windowRect.right > 0;
  }

  /// Touch Mode  - Show btns instead of using right-click, use larger paddings, etc
  // Change default according to thes current platform
  bool _enableTouchMode = UniversalPlatform.isIOS || UniversalPlatform.isAndroid;
  bool get enableTouchMode => _enableTouchMode;
  set enableTouchMode(bool enableTouchMode) {
    _enableTouchMode = enableTouchMode;
  }
}
