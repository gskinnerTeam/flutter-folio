import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/commands/pick_images_command.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as image_size;
import 'package:shortid/shortid.dart';

import 'update_book_modified_command.dart';

class UploadImageScrapsCommand extends BaseAppCommand {
  Future<void> run(String bookId, List<PickedImage> paths) async {
    if (paths?.isEmpty ?? true) return; // Guard against empty lists
    // Create scraps without images to start
    List<ScrapItem> newScraps = paths
        .map((e) => ScrapItem(
            documentId: shortid.generate(),
            bookId: bookId,
            contentType: ContentType.Photo,
            creationTime: TimeUtils.nowMillis))
        .toList();
    // Inject local scraps for loading spinners
    booksModel.currentBookScraps = List.from(booksModel.currentBookScraps)..addAll(newScraps);
    // Send all scraps to the database
    await Future.wait(
      newScraps.map((s) => firebase.addBookScrap(s)).toList(),
    );

    // Upload images and get a public Url
    List<CloudinaryResponse> uploads = await cloudStorage.multiUpload(images: paths);
    uploads.forEach((u) => safePrint(u.secureUrl));

    // Now that we have urls, replace the newScraps with ones that have a url
    List<ScrapItem> items = uploads.map((u) {
      ScrapItem s = newScraps.removeAt(0); // Take first element from list
      PickedImage image = paths.firstWhere((element) {
        String name = element.path ?? element.asset.identifier;
        return name.contains(u.originalFilename);
      }, orElse: () => null);
      double aspect = 1;
      if (image.path != null) {
        // Try and calculate the aspect ratio from the file on disk
        if (image.path.contains("http") == false) {
          final size = image_size.ImageSizeGetter.getSize(FileInput(File(image.path)));
          aspect = size.width / size.height;
        }
      } else if (image.asset != null) {
        aspect = image.asset.originalWidth / image.asset.originalHeight;
      }
      return s.copyWith(data: u.secureUrl, aspect: aspect); // Inject url
    }).toList();

    // Update locally with finished urls
    items.forEach((item) => booksModel.replaceBookScrap(item));

    // Push all scraps to the db
    await Future.wait(
      items.map((s) => firebase.setBookScrap(s)).toList(),
    );

    // Mark book as changed
    UpdateBookModifiedCommand().run(bookId: bookId);
  }
}
