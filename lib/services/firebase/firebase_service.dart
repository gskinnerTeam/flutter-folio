import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/app_keys.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/services/firebase/firebase_service_firedart.dart';
import 'package:flutter_folio/services/firebase/firebase_service_native.dart';

// CollectionKeys
class FireIds {
  static const String users = "users";
  static const String books = "books";
  static const String pages = "pages";
  static const String pageBoxes = "boxes";
  static const String scraps = "scraps";
}

// Returns the correct Firebase instance depending on platform
class FirebaseFactory {
  static bool _initComplete = false;

  // Determine which platforms we can use the native sdk on
  static bool get useNative => DeviceOS.isMobileOrWeb; // || UniversalPlatform.isMacOS;

  static FirebaseService create() {
    FirebaseService service = useNative
        ? NativeFirebaseService()
        : DartFirebaseService(
            apiKey: AppKeys.firebaseApiKey,
            projectId: AppKeys.firestoreProjectId,
          );
    if (_initComplete == false) {
      _initComplete = true;
      service.init();
    }
    print("firestore-${useNative ? "NATIVE" : "DART"} Initialized");
    return service;
  }
}

// Interface / Base class
// Combination of abstract methods that must be implemented, and concrete methods that are shared.
abstract class FirebaseService {
  /// /////////////////////////////////////////////////
  /// Concrete Methods
  /// //////////////////////////////////////////////////

  // shared setUserId method
  String? userId;
  List<String> get userPath => [FireIds.users, userId ?? ""];
  // Helper method for getting a path from keys, and optionally prepending the scope (users/email)
  String getPathFromKeys(List<String> keys, {bool addUserPath = true}) {
    String path = addUserPath ? userPath.followedBy(keys).join("/") : keys.join("/");
    if (FirebaseFactory.useNative) {
      return path.replaceAll("//", "/");
    }
    return path;
  }

  /////////////////////////////////////////////////////////
  // BOOKS
  /////////////////////////////////////////////////////////
  Future<List<ScrapBookData>?> getAllBooks() async {
    List<Map<String, dynamic>>? data = await getCollection(
      [FireIds.books],
    );
    return data?.map((e) => ScrapBookData.fromJson(e)).toList();
  }

  Future<ScrapBookData?> getBook({required String bookId}) async {
    Map<String, dynamic>? data = await getDoc([FireIds.books, bookId]);
    return data == null ? null : ScrapBookData.fromJson(data);
  }

  Future<String> addBook(ScrapBookData value) async {
    return addDoc([
      FireIds.books,
    ], value.toJson(), documentId: value.documentId);
  }

  Future<void> setBook(ScrapBookData value) async {
    await updateDoc([
      FireIds.books,
      value.documentId,
    ], value.toJson());
  }

  Future<void> deleteBook(ScrapBookData value) async {
    await deleteDoc([
      FireIds.books,
      value.documentId,
    ]);
  }

  /////////////////////////////////////////////////////////
  // PAGES
  /////////////////////////////////////////////////////////
  Future<ScrapPageData?> getPage({required String bookId, required String pageId}) async {
    Map<String, dynamic>? data = await getDoc([FireIds.books, bookId, FireIds.pages, pageId]);
    return data == null ? null : ScrapPageData.fromJson(data);
  }

  Future<List<ScrapPageData>?> getAllPages({required String bookId}) async {
    List<Map<String, dynamic>>? data = await getCollection(
      [FireIds.books, bookId, FireIds.pages],
    );
    return data?.map((e) => ScrapPageData.fromJson(e)).toList();
  }

  Future<int> getPageCount(String bookId) async {
    int count = (await getCollection([FireIds.books, bookId, FireIds.pages]))?.length ?? 0;
    return count;
  }

  Future<String> addPage(ScrapPageData value) async {
    return addDoc([
      FireIds.books,
      value.bookId,
      FireIds.pages,
    ], value.toJson(), documentId: value.documentId);
  }

  Future<void> setPage(ScrapPageData value) async {
    await updateDoc([
      FireIds.books,
      value.bookId,
      FireIds.pages,
      value.documentId,
    ], value.toJson());
  }

  Future<void> deletePage({required String bookId, required String pageId}) async {
    await deleteDoc([
      FireIds.books,
      bookId,
      FireIds.pages,
      pageId,
    ]);
  }

  /////////////////////////////////////////////////////////
  // BOOK SCRAPS
  /////////////////////////////////////////////////////////
  Future<List<ScrapItem>?> getAllBookScraps({required String bookId}) async {
    List<Map<String, dynamic>>? data = await getCollection(
      [FireIds.books, bookId, FireIds.scraps],
    );
    return data?.map((e) => ScrapItem.fromJson(e)).toList();
  }

  Future<String> addBookScrap(ScrapItem value) async {
    return addDoc([
      FireIds.books,
      value.bookId,
      FireIds.scraps,
    ], value.toJson(), documentId: value.documentId);
  }

  Future<void> setBookScrap(ScrapItem value) async {
    updateDoc([
      FireIds.books,
      value.bookId,
      FireIds.scraps,
      value.documentId,
    ], value.toJson());
  }

  Future<void> deleteBookScrap({required String bookId, required String scrapId}) async {
    await deleteDoc([
      FireIds.books,
      bookId,
      FireIds.scraps,
      scrapId,
    ]);
  }

  /////////////////////////////////////////////////////////
  // PLACED SCRAPS
  /////////////////////////////////////////////////////////
  Future<List<PlacedScrapItem>?> getAllPlacedScraps({required String bookId, required String pageId}) async {
    List<Map<String, dynamic>>? data =
        await getCollection([FireIds.books, bookId, FireIds.pages, pageId, FireIds.pageBoxes]);
    return data?.map((e) => PlacedScrapItem.fromJson(e)).toList();
  }

  Future<String> addPlacedScrap(PlacedScrapItem value) async {
    return addDoc([
      FireIds.books,
      value.bookId,
      FireIds.pages,
      value.pageId,
      FireIds.pageBoxes,
    ], value.toJson(), documentId: value.documentId);
  }

  Future<void> setPlacedScrap(PlacedScrapItem value) async {
    await updateDoc([
      FireIds.books,
      value.bookId,
      FireIds.pages,
      value.pageId,
      FireIds.pageBoxes,
      value.documentId,
    ], value.toJson());
  }

  Future<void> deletePlacedScrap(PlacedScrapItem value) async {
    await deleteDoc([
      FireIds.books,
      value.bookId,
      FireIds.pages,
      value.pageId,
      FireIds.pageBoxes,
      value.documentId,
    ]);
  }

  /////////////////////////////////////////////////////////
  // USERS
  /////////////////////////////////////////////////////////
  Future<AppUser?> getUser() async {
    try {
      Map<String, dynamic>? data = await getDoc([]);
      return data == null ? null : AppUser.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> addUser(AppUser value) async {
    return await addDoc([FireIds.users], value.toJson(), documentId: value.documentId);
  }

  Future<void> setUserData(AppUser value) async {
    await updateDoc(["/"], value.toJson());
  }

  ///////////////////////////////////////////////////
  // Abstract Methods
  //////////////////////////////////////////////////
  void init();

  // Auth
  Future<AppUser?> signIn({required String email, required String password, bool createAccount = false});
  bool get isSignedIn;
  @mustCallSuper
  Future<void> signOut() async {
    userId = null;
  }

  Stream<Map<String, dynamic>>? getDocStream(List<String> keys);
  Stream<List<Map<String, dynamic>>>? getListStream(List<String> keys);

  Future<Map<String, dynamic>?> getDoc(List<String> keys);
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys);

  Future<String> addDoc(List<String> keys, Map<String, dynamic> json, {String documentId, bool addUserPath = true});
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json);
  Future<void> deleteDoc(List<String> keys);
}

bool checkKeysForNull(List<String> keys) {
  if (keys.contains(null)) {
    print("ERROR: invalid key was passed to firestore: $keys");
    return false;
  }
  return true;
}
