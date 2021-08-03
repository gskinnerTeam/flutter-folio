import '../../_utils/time_utils.dart';
import '../../data/book_data.dart';
import '../commands.dart';
import 'update_book_modified_command.dart';

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
