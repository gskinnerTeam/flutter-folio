import '../../_utils/time_utils.dart';
import '../../data/book_data.dart';
import '../commands.dart';

class UpdateBookCommand extends BaseAppCommand {
  Future<void> run(ScrapBookData book) async {
    booksModel.replaceBook(book);
    await firebase.setBook(book.copyWith(
      lastModifiedTime: TimeUtils.nowMillis,
    ));
  }
}
