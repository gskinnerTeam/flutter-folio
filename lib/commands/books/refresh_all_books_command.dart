import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';

class RefreshAllBooks extends BaseAppCommand {
  Future<List<ScrapBookData>?> run() async {
    List<ScrapBookData>? allBooks = await firebase.getAllBooks();
    if (allBooks != null) {
      CloudStorageService.addMaxSizeToUrlList<ScrapBookData>(
          allBooks, (s) => s.imageUrl, (s, url) => s.copyWith(imageUrl: url));
      booksModel.books = allBooks;
    }
    return booksModel.books;
  }
}
