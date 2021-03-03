import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as image_size;
import 'package:shortid/shortid.dart';

import 'update_book_modified_command.dart';

class UploadImageScrapsCommand extends BaseAppCommand {
  Future<void> run(String bookId, List<String> paths) async {
    if (paths?.isEmpty ?? true) return; // Guard against empty lists

    // Remove any images that are .heic, somehow these have slipped through on iOS in the past.
    paths.removeWhere((p) => p.contains(".heic"));
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
    List<CloudinaryResponse> uploads = await cloudStorage.multiUpload(urls: paths);
    uploads.forEach((u) => safePrint(u.secureUrl));

    // Now that we have urls, replace the newScraps with ones that have a url
    List<ScrapItem> items = uploads.map((u) {
      ScrapItem s = newScraps.removeAt(0); // Take first element from list
      String origPath = paths.firstWhere((element) => element.contains(u.originalFilename), orElse: () => null);
      double aspect = 1;
      // Try and calculate the aspect ratio from the file on disk
      if (origPath != null && origPath.contains("http") == false) {
        final size = image_size.ImageSizeGetter.getSize(FileInput(File(origPath)));
        aspect = size.width / size.height;
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
