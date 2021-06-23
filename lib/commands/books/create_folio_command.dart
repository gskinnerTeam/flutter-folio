import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/books/refresh_all_books_command.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styles.dart';
import 'package:uuid/uuid.dart';

class CreateFolioCommand extends BaseAppCommand {
  Future<String> run({String? title, String? desc}) async {
    // Create an empty book
    ScrapBookData book = ScrapBookData(
      documentId: const Uuid().v1(),
      title: title ?? "",
      desc: desc ?? "",
      creationTime: TimeUtils.nowMillis,
      lastModifiedTime: TimeUtils.nowMillis,
    );
    // Send to server
    String documentId = await firebase.addBook(book);
    if (StringUtils.isNotEmpty(documentId)) {
      // Set as selected book once we get the id back. This will change views
      SetCurrentBookCommand().run(book.copyWith(documentId: documentId));
      // Refresh the book list after a small delay. This allows any transitions to happen before the books lists are updated
      Future.delayed(Times.medium, () => RefreshAllBooks().run());
    }
    return documentId;
  }
}
