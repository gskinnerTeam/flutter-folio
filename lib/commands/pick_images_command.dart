import 'package:file_selector/file_selector.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PickedImage {
  PickedImage({this.path, this.asset});
  String? path;
  Asset? asset;

  String get location => path ?? asset?.identifier ?? "";
}

/// Due to differences in platforms, this Command will return either a list of plain string paths
/// or, when multi-picking images it returns a list of [Asset]s. This is due to implementation details
/// on modern phones, where you may not get a true path to the file, rather you get some sort of promise.
class PickImagesCommand extends BaseAppCommand {
  Future<List<PickedImage>> run({bool allowMultiple = false, bool enableCamera = true}) async {
    List<PickedImage> images = [];
    if (DeviceOS.isDesktopOrWeb) {
      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png']);
      images =
          (await openFiles(acceptedTypeGroups: [typeGroup])).map((file) => PickedImage()..path = file.path).toList();
    } else {
      if (enableCamera) {
        final picker = ImagePicker();
        images = [PickedImage()..path = (await picker.getImage(source: ImageSource.camera))?.path];
      } else {
        int maxImages = 24; // Need to pick some limit
        // Get assets
        List<Asset> assets = await MultiImagePicker.pickImages(
            materialOptions: MaterialOptions(
              actionBarColor: "#${appTheme.accent1.value.toRadixString(16).substring(2, 8)}",
              actionBarTitle: "Pick Scraps",
              statusBarColor: "#${appTheme.accent1.value.toRadixString(16).substring(2, 8)}",
              allViewTitle: "All Photos",
              useDetailsView: false,
              selectCircleStrokeColor: "#000000",
            ),
            enableCamera: true,
            maxImages: allowMultiple ? maxImages : 1);
        for (var asset in assets) {
          images.add(PickedImage()..asset = asset);
        }
      }
    }
    return images;
  }
}
