import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/styled_widgets/dialogs/delete_dialog.dart';

import 'update_book_modified_command.dart';

class DeleteScrapsCommand extends BaseAppCommand {
  Future<bool> run({required String bookId, required List<String> scrapIds}) async {
    // Guard against empty ids
    if ((scrapIds.isEmpty)) return false;

    // Show dialog
    String pluralScraps = StringUtils.pluralize("scrap", scrapIds.length);
    bool doDelete = await showDialog(
            context: mainContext,
            builder: (_) {
              return DeleteDialog(
                title: "Delete ${scrapIds.length} $pluralScraps?",
                desc1: "Are you sure you want to permanently\ndelete the selected $pluralScraps?",
              );
            }) ??
        false;
    //Delete
    if (doDelete) {
      for (final id in scrapIds) {
        // Clear local data
        booksModel.removeBookScrapById(id);
        // Delete from db
        firebase.deleteBookScrap(bookId: bookId, scrapId: id);
      }
      // Mark book as changed
      UpdateBookModifiedCommand().run(bookId: bookId);
      return true;
    }
    return false;
  }
}
