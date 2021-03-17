import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';

class RefreshCurrentBookCommand extends BaseAppCommand {
  Future<void> run({bool book = true, bool pages = true, bool scraps = true}) async {
    String? bookId = booksModel.currentBookId;
    if (bookId == null) return;
    List<Future> futures = [
      if (book)
        firebase.getBook(bookId: bookId).then((value) {
          if (value == null) return;
          booksModel.currentBook = value;
        }),
      if (pages)
        firebase.getAllPages(bookId: bookId).then((value) {
          if (value == null) return;
          booksModel.currentBookPages = value..removeWhere((p) => p.documentId == "");
        }),
      if (scraps)
        firebase.getAllBookScraps(bookId: bookId).then((value) {
          if (value == null) return;
          CloudStorageService.addMaxSizeToUrlList<ScrapItem>(
            value,
            (s) => s.data,
            (s, url) => s.copyWith(data: url),
          );
          booksModel.currentBookScraps = value;
        }),
    ];
    await Future.wait(futures);
  }

  void onlyScraps() => run(book: false, pages: false);
  void onlyPages() => run(book: false);
}
