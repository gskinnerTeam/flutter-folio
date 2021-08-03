import '../../data/book_data.dart';
import '../commands.dart';
import 'update_book_modified_command.dart';

class UpdatePageCommand extends BaseAppCommand {
  Future<void> run(ScrapPageData page) async {
    booksModel.replacePage(page);
    await firebase.setPage(page);
    UpdateBookModifiedCommand().run(bookId: page.bookId);
  }
}
