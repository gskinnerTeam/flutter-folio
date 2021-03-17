// @dart=2.12
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as image_size;
import 'package:uuid/uuid.dart';

import 'update_book_modified_command.dart';

class UploadImageScrapsCommand extends BaseAppCommand {
  Future<void> run(String bookId, List<String> paths) async {
    if (paths.isEmpty) return; // Guard against empty lists

    // Remove any images that are .heic, somehow these have slipped through on iOS in the past.
    paths.removeWhere((p) => p.contains(".heic"));
    // Create scraps without images to start
    List<ScrapItem> newScraps = paths
        .map((e) => ScrapItem(
            documentId: Uuid().v1(),
            bookId: bookId,
            data: e,
            contentType: ContentType.Photo,
            creationTime: TimeUtils.nowMillis))
        .toList();
    // Inject local scraps for loading spinners
    booksModel.currentBookScraps = List.from(booksModel.currentBookScraps ?? [])..addAll(newScraps);
    // Send all scraps to the database
    await Future.wait(
      newScraps.map((s) => firebase.addBookScrap(s)).toList(),
    );

    // Upload images and get a public Url
    List<CloudinaryResponse> uploads = await cloudStorage.multiUpload(urls: paths);
    uploads.forEach((upload) => safePrint(upload.secureUrl!));

    // Now that we have urls, replace the newScraps with ones that have a url
    List<ScrapItem> items = uploads.map((upload) {
      ScrapItem s = newScraps.removeAt(0); // Take first element from list
      String? originalFilename = upload.originalFilename;
      // Try and calculate the aspect ratio from the file on disk
      double aspect = 1;
      if (originalFilename != null) {
        String origPath = paths.firstWhereOrDefault((element) => element.contains(originalFilename), defaultValue: "");
        if (origPath.length > 0 && origPath.contains("http") == false) {
          final size = image_size.ImageSizeGetter.getSize(FileInput(File(origPath)));
          aspect = size.width / size.height;
        }
      }
      // Prefer the https url if we have one
      String? url = upload.secureUrl ?? upload.url;
      if (url != null) {
        return s.copyWith(data: url, aspect: aspect); // Inject url
      }
      return s;
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
