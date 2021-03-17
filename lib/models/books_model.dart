import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/data/book_data.dart';

class BooksModel extends EasyNotifier {
  List<T> copyList<T>(List<T>? list) => List.from(list ?? []);

  /// //////////////////////////////////////
  /// All books
  List<ScrapBookData>? _books;
  List<ScrapBookData>? get books => _books;
  set books(List<ScrapBookData>? value) {
    value?.removeWhere((element) => StringUtils.isEmpty(element.documentId));
    value?.sort((item1, item2) => item1.lastModifiedTime > item2.lastModifiedTime ? -1 : 1);
    notify(() => _books = value);
  }

  void removeBookById(String documentId) => notify(() {
        if (books == null) return;
        books = List.from(books ?? [])..removeWhere((b) => b.documentId == documentId);
        if (documentId == currentBookId) currentBook = null;
      });

  void replaceBook(ScrapBookData value) {
    if (this.books == null) return;
    bool equals(ScrapBookData? b1, ScrapBookData b2) => b1?.documentId == b2.documentId;
    List<ScrapBookData> books = copyList(this.books);
    for (var i = books.length; i-- > 0;) {
      if (equals(value, books[i])) books[i] = value;
    }
    this.books = List.from(books);
    if (equals(currentBook, value)) currentBook = value;
  }

  /// //////////////////////////////////////
  /// Current book
  ScrapBookData? _currentBook;
  List<ScrapPageData>? _currentBookPages;
  List<ScrapItem>? _currentBookScraps;
  ScrapBookData? get currentBook => _currentBook;
  set currentBook(ScrapBookData? value) {
    notify(() => _currentBook = value);
    if (value == null) {
      currentPage = null;
      currentBookPages = null;
      currentBookScraps = null;
    }
  }

  String? get currentBookId => currentBook?.documentId;

  List<ScrapPageData>? get currentBookPages => _currentBookPages;
  set currentBookPages(List<ScrapPageData>? value) {
    notify(() => _currentBookPages = value);
  }

  List<ScrapItem>? get currentBookScraps => _currentBookScraps;
  set currentBookScraps(List<ScrapItem>? value) => notify(() => _currentBookScraps = value);

  void removePageById(String documentId) => notify(() {
        if (currentBookPages == null) return;
        currentBookPages = copyList(currentBookPages)..removeWhere((p) => p.documentId == documentId);
        if (currentPageId == documentId) {
          currentPage = null;
        }
      });

  void removeBookScrapById(String documentId) => notify(() {
        if (currentBookScraps == null) return;
        currentBookScraps = copyList(currentBookScraps)..removeWhere((scrap) => scrap.documentId == documentId);
      });

  void replacePage(ScrapPageData value) {
    if (currentBookPages == null) return;
    bool equals(ScrapPageData? p1, ScrapPageData p2) => p1?.documentId == p2.documentId;
    List<ScrapPageData> pages = copyList(currentBookPages);
    for (var i = pages.length; i-- > 0;) {
      if (equals(value, pages[i])) {
        pages[i] = value;
      }
    }
    currentBookPages = pages;
    if (equals(currentPage, value)) currentPage = value;
    notify();
  }

  void replaceBookScrap(ScrapItem value) {
    if (currentBookScraps == null) return;
    bool equals(ScrapItem p1, ScrapItem p2) => p1.documentId == p2.documentId;
    List<ScrapItem> scraps = copyList(currentBookScraps);
    for (var i = scraps.length; i-- > 0;) {
      if (equals(value, scraps[i])) scraps[i] = value;
    }
    currentBookScraps = scraps;
  }

  /// //////////////////////////////////////
  /// Current page
  ScrapPageData? _currentPage;
  List<PlacedScrapItem>? _currentPageScraps;
  ScrapPageData? get currentPage => _currentPage;
  set currentPage(ScrapPageData? value) {
    if (value == null) {
      currentPageScraps = null;
    }
    notify(() => _currentPage = value);
  }

  String? get currentPageId => currentPage?.documentId;

  List<PlacedScrapItem>? get currentPageScraps => _currentPageScraps;
  set currentPageScraps(List<PlacedScrapItem>? value) => notify(() => _currentPageScraps = value);

  void replaceCurrentPageScrap(PlacedScrapItem value, {bool silent = false}) {
    if (currentPageScraps == null) return;
    bool equals(PlacedScrapItem p1, PlacedScrapItem p2) => p1.documentId == p2.documentId;
    List<PlacedScrapItem> scraps = copyList(currentPageScraps);
    for (var i = scraps.length; i-- > 0;) {
      if (equals(value, scraps[i])) scraps[i] = value;
    }
    _currentPageScraps = scraps;
    if (silent == false) notify();
  }

  void removePageScrapById(String documentId) {
    if (currentPageScraps == null) return;
    currentPageScraps = copyList(currentPageScraps)..removeWhere((s) => s.documentId == documentId);
  }

  void reset() => currentBook = null;
}
