import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/toaster.dart';

class ShiftPlacedScrapsSortOrderCommand extends BaseAppCommand {
  Future<void> run(int indexesToShift, PlacedScrapItem scrapItem) async {
    // Fetch the book and try to get the current sortIndex of this page
    ScrapPageData? page = booksModel.currentPage;
    if (page == null) return;

    page = page.copyWith(
      boxOrder: _move(page.boxOrder, scrapItem.documentId, indexesToShift),
    );
    Toaster.showToast(mainContext, indexesToShift < 0 ? "Sent back" : "Moved forward");
    booksModel.replacePage(page);
    booksModel.currentPageScraps = List.from(booksModel.currentPageScraps ?? []);
    // Update firebase
    firebase.setPage(page);
  }

  List<String> _move(List<String> existing, String value, int indexesToShift) {
    int i = existing.indexOf(value);
    // If it doesn't exist in the list, then use the last item or -1, and move from there.
    if (i == -1) i = existing.length - 1;
    int newIndex = (i + indexesToShift).clamp(0, existing.length - 1).toInt();
    // Remove the item if it existed in the list
    if (i != -1) {
      existing.removeAt(i);
    }
    // Insert the new item back in at the correct index, or 0 if it didn't previous exist
    return existing..insert(newIndex, value);
  }
}
