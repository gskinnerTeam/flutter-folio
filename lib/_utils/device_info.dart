import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

class DeviceInfo {
  static bool get isDesktop => UniversalPlatform.isWindows || UniversalPlatform.isMacOS || UniversalPlatform.isLinux;

  static bool get isDesktopOrWeb => isDesktop || kIsWeb == true;

  static bool get isMobile => !isDesktopOrWeb;
}
