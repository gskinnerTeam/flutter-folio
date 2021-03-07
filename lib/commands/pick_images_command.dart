import 'package:file_selector/file_selector.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PickImagesCommand extends BaseAppCommand {
  Future<List<String>> run({bool allowMultiple = false, bool enableCamera = true}) async {
    List<String> paths = [];
    if (DeviceInfo.isDesktopOrWeb) {
      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png']);
      paths = (await openFiles(acceptedTypeGroups: [typeGroup])).map((e) {
        return e.path;
      }).toList();
    } else {
      int maxImages = 24; // Need to pick some limit
      paths = (await MultiImagePicker.pickImages(enableCamera: enableCamera, maxImages: allowMultiple ? maxImages : 1))
          .map((asset) => asset.identifier)
          .toList();
    }
    paths.removeWhere((p) => StringUtils.isEmpty(p));
    return paths;
  }
}
