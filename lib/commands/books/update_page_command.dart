import 'package:flutter_folio/commands/books/update_book_modified_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';

class UpdatePageCommand extends BaseAppCommand {
  Future<void> run(ScrapPageData page) async {
    booksModel.replacePage(page);
    await firebase.setPage(page);
    UpdateBookModifiedCommand().run(bookId: page.bookId);
  }
}
