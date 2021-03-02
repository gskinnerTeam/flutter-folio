import 'dart:io';

import 'package:flutter_folio/_utils/path_utils.dart';
import 'package:path/path.dart' as p;

import 'universal_file.dart';

class IoFileWriter implements UniversalFile {
  Directory dataPath;

  @override
  String fileName;

  IoFileWriter(this.fileName);

  String get fullPath => p.join(dataPath.path, fileName);

  Future<void> getDataPath() async {
    if (dataPath != null) return;
    dataPath = Directory(await PathUtil.dataPath);
    if (Platform.isWindows || Platform.isLinux) {
      createDirIfNotExists(dataPath);
    }
  }

  @override
  Future<String> read() async {
    await getDataPath();
    print("Loading file @ $fullPath");
    return await File("$fullPath").readAsString().catchError((Object e) {
      print(e);
      return null;
    });
  }

  @override
  Future<void> write(String value, [bool append = false]) async {
    await getDataPath();
    print("[IoFileWriter] Writing file to: $fullPath");
    try {
      FileMode writeMode = append ? FileMode.append : FileMode.write;
      File("$fullPath").writeAsString(value, mode: writeMode);
    } catch (e) {
      print("$e");
    }
  }

  static void createDirIfNotExists(Directory dir) async {
    // Create directory if it doesn't exist
    if (dir != null && !await dir.exists()) {
      // Catch error since disk io can always fail.
      try {
        await dir.create(recursive: true);
      } catch (e) {
        print("$e");
      }
    }
  }
}

UniversalFile getPlatformFileWriter(String string) => IoFileWriter(string);
