import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';

class RefreshCurrentPageCommand extends BaseAppCommand {
  Future<void> run() async {
    if (booksModel.currentPage == null) return;
    String bookId = booksModel.currentPage.bookId;
    String pageId = booksModel.currentPage.documentId;
    List<Future> futures = [
      firebase.getPage(bookId: bookId, pageId: pageId).then((value) {
        booksModel.currentPage = value;
      }),
      firebase.getAllPlacedScraps(bookId: bookId, pageId: pageId).then((value) {
        CloudStorageService.addMaxSizeToUrlList<PlacedScrapItem>(
            value, (s) => s.data, (s, url) => s.copyWith(data: url));
        booksModel.currentPageScraps = value
          ..removeWhere((element) {
            return element.documentId == null;
          });
      }),
    ];
    await Future.wait(futures);
  }
}
