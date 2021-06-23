import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/books/create_placed_scraps_command.dart';
import 'package:flutter_folio/commands/books/update_page_count_command.dart';
import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:uuid/uuid.dart';

class CreatePageCommand extends BaseAppCommand {
  Future<void> run() async {
    ScrapBookData? currentBook = booksModel.currentBook;
    List<ScrapPageData>? currentPages = booksModel.currentBookPages;
    if (currentBook == null || currentPages == null) return;
    // Increment pageCount
    int count = await UpdatePageCountCommand().run(currentPages.length + 1);
    // Create new page
    ScrapPageData newPage = ScrapPageData(
      documentId: const Uuid().v1(),
      bookId: currentBook.documentId,
      title: "Page $count",
      desc: "Add a description...",
      boxOrder: [],
    );

    /// Add page locally
    booksModel.currentBookPages = List.from(currentPages)..add(newPage);
    booksModel.currentPage ??= newPage;

    /// Add to database
    String pageId = await firebase.addPage(newPage);

    // Add a hidden scrap, this sidesteps a bug in firedart regarding empty collections.
    ScrapItem emptyScrap = ScrapItem(bookId: newPage.bookId, contentType: ContentType.Hidden, data: "");
    await CreatePlacedScrapCommand().run(pageId: pageId, size: Size.zero, scraps: [emptyScrap]);
  }
}
