//If in web, this class will write a string to the prefs file, using filename as key
//If on desktop or mobile, write to the appData folder

import 'universal_file_locator.dart' if (dart.library.html) 'web_file.dart' if (dart.library.io) 'io_file.dart';

abstract class UniversalFile {
  late final String fileName;

  Future<void> write(String value, [bool append = false]);

  Future<String?> read();

  factory UniversalFile(String fileName) => getPlatformFileWriter(fileName);
}
