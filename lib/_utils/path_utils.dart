import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdgDirectories;

class PathUtil {
  static Future<String?> get dataPath async {
    String? result;
    if (Platform.isLinux) {
      result = "${xdgDirectories.dataHome.path}/flutterfolio";
    } else {
      try {
        return (await getApplicationSupportDirectory()).path;
      } catch (e) {
        print("$e");
      }
    }
    return result;
  }

  static Future<String> get homePath async {
    return "~/";
  }
}
