import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/main.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:provider/provider.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Create core models & services
  FirebaseService firebase = _MockFirebaseService();
  BooksModel booksModel = BooksModel();
  AppModel appModel = AppModel(booksModel, firebase);

  // /// Run
  runApp(MultiProvider(
    providers: [
      // Firebase
      Provider.value(value: firebase),
      // Cloudinary
      Provider(create: (_) => CloudStorageService()),
      // App Model - Stores data related to global settings or app modes
      ChangeNotifierProvider.value(value: appModel),
      // BooksModel - Stores data about the content in the app
      ChangeNotifierProvider.value(value: booksModel),
    ],
    child: const AppBootstrapper(),
  ));
}

class _MockFirebaseService implements FirebaseService {
  final _mockUser = AppUser(
    documentId: 'exampleDocId',
    email: 'shawn@test.com',
    fireId: 'exampleUser',
  );

  @override
  String? userId = 'exampleUser';

  AppUser? _currentUser;

  @override
  bool get isSignedIn => _currentUser != null;

  @override
  List<String> get userPath => [FireIds.users, userId ?? ''];

  @override
  Future<String> addBook(ScrapBookData value) {
    throw UnimplementedError();
  }

  @override
  Future<String> addBookScrap(ScrapItem value) {
    throw UnimplementedError();
  }

  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json, {String? documentId, bool addUserPath = true}) {
    throw UnimplementedError();
  }

  @override
  Future<String> addPage(ScrapPageData value) {
    throw UnimplementedError();
  }

  @override
  Future<String> addPlacedScrap(PlacedScrapItem value) {
    throw UnimplementedError();
  }

  @override
  Future<String> addUser(AppUser value) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBook(ScrapBookData value) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBookScrap({required String bookId, required String scrapId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDoc(List<String> keys) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePage({required String bookId, required String pageId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePlacedScrap(PlacedScrapItem value) {
    throw UnimplementedError();
  }

  @override
  Future<List<ScrapBookData>?> getAllBooks() async {
    return <ScrapBookData>[
      for (var i = 0; i < 50; i++) ScrapBookData.random(),
    ];
  }

  @override
  Future<List<ScrapItem>?> getAllBookScraps({required String bookId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ScrapPageData>?> getAllPages({required String bookId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<PlacedScrapItem>?> getAllPlacedScraps({required String bookId, required String pageId}) {
    throw UnimplementedError();
  }

  @override
  Future<ScrapBookData?> getBook({required String bookId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getDoc(List<String> keys) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>>? getDocStream(List<String> keys) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Map<String, dynamic>>>? getListStream(List<String> keys) {
    throw UnimplementedError();
  }

  @override
  Future<ScrapPageData?> getPage({required String bookId, required String pageId}) {
    throw UnimplementedError();
  }

  @override
  Future<int> getPageCount(String bookId) {
    throw UnimplementedError();
  }

  @override
  String getPathFromKeys(List<String> keys, {bool addUserPath = true}) {
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> getUser() async => _mockUser;

  @override
  void init() {
    // Nothing to init in the mock.
  }

  @override
  Future<void> setBook(ScrapBookData value) async {
    // Pass.
  }

  @override
  Future<void> setBookScrap(ScrapItem value) {
    throw UnimplementedError();
  }

  @override
  Future<void> setPage(ScrapPageData value) {
    // TODO: implement setPage
    throw UnimplementedError();
  }

  @override
  Future<void> setPlacedScrap(PlacedScrapItem value) {
    throw UnimplementedError();
  }

  @override
  Future<void> setUserData(AppUser value) {
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> signIn({required String email, required String password, bool createAccount = false}) async {
    _currentUser = _mockUser;
    return _mockUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
