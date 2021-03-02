import 'package:file_chooser/file_chooser.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PickImagesCommand extends BaseAppCommand {
  Future<List<String>> run({bool allowMultiple = false, bool enableCamera = true}) async {
    List<String> paths = [];
    if (DeviceInfo.isDesktop) {
      FileChooserResult result = await showOpenPanel(
        //initialDirectory: initialPath,
        allowedFileTypes: [
          FileTypeFilterGroup(
            label: "images",
            fileExtensions: [
              "png",
              "jpg",
              "jpeg"
            ], //"gif", "webm" // removed gif/web because they didn't seem  to work on web
          ),
        ],
        allowsMultipleSelection: allowMultiple,
        canSelectDirectories: false,
        confirmButtonText: "Select Images",
      );
      paths = List.from(result.paths);
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
