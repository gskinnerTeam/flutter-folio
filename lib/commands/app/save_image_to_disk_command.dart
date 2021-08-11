import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:file_selector/file_selector.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/commands/commands.dart';

class SaveImageToDiskCommand extends BaseAppCommand {
  //TODO: Add support for web https://github.com/flutter/flutter/issues/78142
  static bool get canUse => DeviceOS.isDesktop;

  Future<void> run(String url) async {
    if (canUse == false) return;
    String fileName = url.split("/").last;
    final path = await file_selector.getSavePath(acceptedTypeGroups: [
      XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png'])
    ], suggestedName: fileName, confirmButtonText: "Save");
    print(path);
    // if (path != null) {
    //   final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
    //   final Uint8List bytes = imageData.buffer.asUint8List();
    //   final file = XFile.fromData(bytes);
    //   file.saveTo(path);
    //}
  }
}
