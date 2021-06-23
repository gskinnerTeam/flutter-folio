import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/books/update_page_count_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/dialogs/delete_dialog.dart';

class DeletePageCommand extends BaseAppCommand {
  Future<void> run(ScrapPageData page) async {
    // Show dialog
    bool doDelete = await showDialog(
            context: mainContext,
            builder: (_) {
              String title = StringUtils.isNotEmpty(page.title) ? "\"${page.title}\"" : "";
              if (title.length > 30) title = title.substring(0, 30) + "...";
              return DeleteDialog(
                title: "Delete Page $title?",
                desc1: "Are you sure you want to permanently\ndelete this page?",
              );
            }) ??
        false;
    //Delete
    if (doDelete) {
      // If we're deleting the current page, we will want to select another one if we can.
      bool wasCurrentPage = booksModel.currentPage?.documentId == page.documentId;

      // Remove page locally
      booksModel.removePageById(page.documentId);
      bool hasPages = booksModel.currentBookPages?.isNotEmpty ?? false;
      if (wasCurrentPage && hasPages) {
        booksModel.currentPage = booksModel.currentBookPages?.first;
      }

      // Select a replacement page if we can, since we deleted the current one
      if (wasCurrentPage && hasPages) {
        // Decrement pageCount
        await UpdatePageCountCommand().run(max(booksModel.currentBookPages!.length - 1, 0));
      }

      // Remove page from db
      await firebase.deletePage(bookId: page.bookId, pageId: page.documentId);

      // Decrement the page count
      bool isCurrentBook = booksModel.currentBookId == page.bookId;
      ScrapBookData? book = isCurrentBook ? booksModel.currentBook : (await firebase.getBook(bookId: page.bookId));
      if (book != null) {
        UpdatePageCountCommand().run(book.pageCount - 1, book: book);
      }
    }
  }
}
