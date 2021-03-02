import 'package:flutter/cupertino.dart';
import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/data/book_data.dart';

import 'main_app_context.dart';
import 'scrapboard_controller_books.dart';
import 'scrapboard_controller_pages.dart';
import 'scrapboard_controller_scraps.dart';

// Use multiple controllers for this model because it's so big
class ScrapboardController {
  final BooksController books;
  final PagesController pages;
  final ScrapsController scraps;

  ScrapboardController({@required this.books, @required this.pages, @required this.scraps});
}

class ScrapboardModel extends EasyNotifier {
  ScrapboardController controller;
  MainAppContext appContext;

  ScrapboardModel(this.appContext) {
    controller = ScrapboardController(
      scraps: ScrapsController(this),
      pages: PagesController(this),
      books: BooksController(this),
    );
  }

  /// All Books
  List<ScrapBookData> _allBooks;
  List<ScrapBookData> get allBooks => _allBooks;
  set allBooks(List<ScrapBookData> allBooks) {
    notify(() => _allBooks = allBooks);
  }

  /// Selected Book
  String get selectedBookId => selectedBook?.documentId;
  ScrapBookData _selectedBook;
  ScrapBookData get selectedBook => _selectedBook;
  set selectedBook(ScrapBookData selectedBook) {
    notify(() => _selectedBook = selectedBook);
  }

  /// Selected ScrapPile
  List<ScrapItem> _scrapPile;
  List<ScrapItem> get scrapPile => _scrapPile;
  set scrapPile(List<ScrapItem> scrapPile) {
    notify(() => _scrapPile = scrapPile);
  }

  /// All Pages
  List<ScrapPageData> _allPages;
  List<ScrapPageData> get allPages => _allPages;
  set allPages(List<ScrapPageData> allPages) {
    notify(() => _allPages = allPages);
  }

  /// Selected Page
  ScrapPageData _selectedPage;
  String get selectedPageId => selectedPage?.documentId;
  ScrapPageData get selectedPage => _selectedPage;
  set selectedPage(ScrapPageData selectedPage) {
    notify(() => _selectedPage = selectedPage);
  }

  /// Selected Page Scraps
  List<PlacedScrapItem> _placedScraps;
  List<PlacedScrapItem> get placedScraps => _placedScraps;
  set placedScraps(List<PlacedScrapItem> placedScraps) {
    notify(() => _placedScraps = placedScraps);
  }
}
