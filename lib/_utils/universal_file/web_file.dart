import 'package:shared_preferences/shared_preferences.dart';

import 'universal_file.dart';

class WebFileWriter implements UniversalFile {
  SharedPreferences? prefs;

  @override
  String fileName;

  String _lastWrite = "";

  WebFileWriter(this.fileName);

  Future<void> initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<String?> read() async {
    await initPrefs();
    String? value = prefs?.getString(fileName);
    //print("Reading pref: $fileName = $value");
    return value;
  }

  @override
  Future<void> write(String value, [bool append = false]) async {
    await initPrefs();
    if (append) {
      _lastWrite = await read() ?? "";
      value = _lastWrite + value;
    }
    //print("Write: $fileName = $value");
    _lastWrite = value;
    await prefs?.setString(fileName, value);
  }
}

UniversalFile getPlatformFileWriter(String fileName) => WebFileWriter(fileName);
