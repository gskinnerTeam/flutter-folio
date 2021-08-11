import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/commands/pick_images_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as image_size;
import 'package:uuid/uuid.dart';

import 'update_book_modified_command.dart';

class UploadImageScrapsCommand extends BaseAppCommand {
  Future<void> run(String bookId, List<PickedImage> paths) async {
    if (paths.isEmpty) return; // Guard against empty lists
    // Create scraps without images to start
    List<ScrapItem> newScraps = paths
        .map((e) => ScrapItem(
              documentId: const Uuid().v1(),
              bookId: bookId,
              contentType: ContentType.Photo,
              creationTime: TimeUtils.nowMillis,
            ))
        .toList();
    // Inject local scraps for loading spinners
    booksModel.currentBookScraps = List.from(booksModel.currentBookScraps ?? [])..addAll(newScraps);

    // Send all scraps to the database, //TODO: Why do we send these if we already made local copies? Can't we just wait?
    await Future.wait(newScraps.map((s) => firebase.addBookScrap(s)).toList());

    // Upload images and get a public Url
    List<CloudinaryResponse> uploads = await cloudStorage.multiUpload(images: paths);
    for (final u in uploads) {
      log(u.secureUrl);
    }

    // Now that we have urls, replace the newScraps with ones that have a url
    List<ScrapItem> items = uploads.map((upload) {
      ScrapItem s = newScraps.removeAt(0); // Take first element from list

      String? originalFilename = upload.originalFilename;

      // Get picked image for this upload
      double aspect = 1;
      PickedImage? pickedImage = List<PickedImage?>.from(paths)
          .firstWhere((img) => img?.path?.contains(originalFilename) ?? false, orElse: () => null);
      if (pickedImage != null) {
        if (pickedImage.path != null && (pickedImage.path?.contains("http") ?? false) == false) {
          final size = image_size.ImageSizeGetter.getSize(FileInput(File(pickedImage.path!)));
          aspect = size.width / size.height;
        } else if (pickedImage.asset != null && pickedImage.asset!.originalWidth != null) {
          aspect = pickedImage.asset!.originalWidth! / pickedImage.asset!.originalHeight!;
        }
      }
      // Prefer the https url if we have one
      String? url = upload.secureUrl;
      return s.copyWith(data: url, aspect: aspect);
    }).toList();

    // Update locally with finished urls
    for (final item in items) {
      booksModel.replaceBookScrap(item);
    }

    // Push all scraps to the db
    await Future.wait(
      items.map((s) => firebase.setBookScrap(s)).toList(),
    );

    // Mark book as changed
    UpdateBookModifiedCommand().run(bookId: bookId);
  }
}
