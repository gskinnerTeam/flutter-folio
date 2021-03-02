import 'dart:math';

import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_utils/time_utils.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';

import 'scrapboard_model.dart';

class BooksController {
  BooksController(this.model);
  final ScrapboardModel model;

  FirebaseService get firebase => model.appContext.firebase;

  // Books
  Future<void> create() async {
    // Create an empty book
    ScrapBookData book = ScrapBookData(
      title: "",
      desc: "",
      creationTime: DateTime.now().millisecondsSinceEpoch,
      lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
    );
    // Send to server
    String id = await firebase.addBook(book);
    // Set as selected book once we get the id back...
    setCurrentBook(bookId: id);
  }

  void setCurrentBook({String bookId}) async {
    if (StringUtils.isEmpty(bookId)) {
      model.selectedBook = null;
    } else {
      model.selectedBook = await firebase.getBook(bookId: bookId);
      // // If we have any pages, set the first one as the current page
      if (model.allPages?.isNotEmpty ?? false) {
        setCurrentPage(pageId: model.allPages[0].documentId);
      }
    }
  }

  void setCurrentPage({String pageId}) async {
    if (StringUtils.isEmpty(pageId)) {
      model.selectedPage = null;
    } else {
      String pageId = model.selectedPageId;
      List<Future> futures = [
        firebase.getPage(bookId: pageId, pageId: pageId).then(
              (value) => model.selectedPage = value,
            ),
        firebase.getAllPlacedScraps(bookId: pageId, pageId: pageId).then(
              (value) => model.placedScraps = value,
            ),
      ];
      await Future.wait(futures);
    }
  }

  Future<void> refresh() async => setCurrentBook(bookId: model.selectedBookId);

  Future<void> refreshAll() async => model.allBooks = await firebase.getAllBooks();

  Future<void> update(ScrapBookData book) async => firebase.setBook(book);

  Future<void> setModified(ScrapBookData book) async {
    firebase.setBook(book.copyWith(lastModifiedTime: TimeUtils.nowMillis));
  }

  Future<void> setCoverPhoto(String imageUrl) async {
    model.selectedBook = model.selectedBook.copyWith(imageUrl: imageUrl);
    firebase.setBook(model.selectedBook);
  }

  Future<int> setPageCount(int value) async {
    value = max(0, value);
    model.selectedBook = model.selectedBook.copyWith(
      lastModifiedTime: TimeUtils.nowMillis,
      pageCount: value,
    );
    await firebase.setBook(model.selectedBook);
    return value;
  }

  Future<int> incrementPageCount() async => setPageCount((model.selectedBook?.pageCount ?? 0) + 1);
  Future<int> decrementPageCount() async => setPageCount((model.selectedBook?.pageCount ?? 0) - 1);

  Future<void> delete(String bookId) async {
    model.allBooks.removeWhere((element) => element.documentId == bookId);
    model.notify();
    firebase.deleteBook(ScrapBookData()..documentId);
  }
}
