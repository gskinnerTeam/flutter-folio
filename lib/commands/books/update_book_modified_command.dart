import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';

class UpdateBookModifiedCommand extends BaseAppCommand {
  Future<void> run({String? bookId, ScrapBookData? book}) async {
    assert(
        StringUtils.isNotEmpty(bookId) || book != null, "You must pass either an id or an instance to this Command.");
    // fetch a book, or use the one passed in
    if (bookId != null) {
      book ??= await firebase.getBook(bookId: bookId);
    }
    if (book != null) {
      book = book.copyWith(lastModifiedTime: TimeUtils.nowMillis);
      booksModel.replaceBook(book);
      firebase.setBook(book);
    }
  }
}
