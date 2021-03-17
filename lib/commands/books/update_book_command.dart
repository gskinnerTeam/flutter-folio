import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';

class UpdateBookCommand extends BaseAppCommand {
  Future<void> run(ScrapBookData book) async {
    booksModel.replaceBook(book);
    await firebase.setBook(book.copyWith(
      lastModifiedTime: TimeUtils.nowMillis,
    ));
  }
}
