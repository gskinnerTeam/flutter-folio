import 'package:flutter/material.dart';

import '../../data/book_data.dart';
import '../../styled_widgets/dialogs/delete_dialog.dart';
import '../commands.dart';

class DeleteBookCommand extends BaseAppCommand {
  Future<void> run(ScrapBookData book) async {
    // Show dialog
    bool doDelete = await showDialog(
            context: mainContext,
            builder: (_) => DeleteDialog(
                  title: "Delete Folio",
                  desc1: "Are you sure you want to permanently\ndelete the selected folio?",
                  desc2: "\"${book.title}\"",
                )) ??
        false;
    //Delete
    if (doDelete) {
      // Delete locally right away
      booksModel.removeBookById(book.documentId);
      // Sent to database
      firebase.deleteBook(book);

      while ((booksModel.books?.length ?? 0) > 30) {
        final book = booksModel.books!.last;
        booksModel.removeBookById(book.documentId);
        firebase.deleteBook(book);
      }
    }
  }
}
