import 'dart:io';

class FileUtils {
  Future<String?> readAsString(String path) async {
    try {
      return await File(path).readAsString();
    } catch (e) {
      print("$e");
    }
    return null;
  }

  Future<void> writeAsString(String path, String contents) async {
    try {
      await File(path).writeAsString(contents, flush: true);
    } catch (e) {
      print("$e");
    }
    return;
  }
}
