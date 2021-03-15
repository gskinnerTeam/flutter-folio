// @dart=2.12
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';

class RefreshCurrentPageCommand extends BaseAppCommand {
  Future<void> run() async {
    String? bookId = booksModel.currentPage?.bookId;
    String? pageId = booksModel.currentPage?.documentId;
    if (bookId == null || pageId == null) return;
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
