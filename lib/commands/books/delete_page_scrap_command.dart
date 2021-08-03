import '../../data/book_data.dart';
import '../commands.dart';
import 'update_book_modified_command.dart';

class DeletePageScrapCommand extends BaseAppCommand {
  Future<void> run(PlacedScrapItem scrap) async {
    booksModel.removePageScrapById(scrap.documentId);
    UpdateBookModifiedCommand().run(bookId: scrap.bookId);
    await firebase.deletePlacedScrap(scrap);
  }
}
