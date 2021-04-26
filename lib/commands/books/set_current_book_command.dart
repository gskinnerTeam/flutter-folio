import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/commands/books/refresh_current_book_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'set_current_page_command.dart';

class SetCurrentBookCommand extends BaseAppCommand {
  Future<void> run(ScrapBookData? book, {bool setInitialPage = true}) async {
    booksModel.currentBook = book;
    if (book != null) {
      // Because TextEditing relies on FocusOut for saving, we have to make sure we focus out before changing books
      InputUtils.unFocus();
      // Load new book contents
      await RefreshCurrentBookCommand().run();
      // If we have any pages, set the first one as the current page
      bool hasPages = booksModel.currentBookPages?.isNotEmpty ?? false;
      if (hasPages) {
        ScrapPageData? firstPage = booksModel.currentBookPages?.first;
        if (setInitialPage && firstPage != null) {
          await SetCurrentPageCommand().run(firstPage);
        }
      }
    }
  }
}
