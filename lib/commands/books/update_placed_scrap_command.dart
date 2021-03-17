import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/commands/books/update_book_modified_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';

class UpdatePageScrapCommand extends BaseAppCommand {
  Future<void> run(PlacedScrapItem scrapItem, {bool localOnly = false}) async {
    PlacedScrapItem newScrap = scrapItem.copyWith(lastModifiedTime: TimeUtils.nowMillis);
    booksModel.replaceCurrentPageScrap(newScrap);
    if (localOnly == false) {
      firebase.setPlacedScrap(newScrap);
      UpdateBookModifiedCommand().run(bookId: scrapItem.bookId);
    }
  }
}
