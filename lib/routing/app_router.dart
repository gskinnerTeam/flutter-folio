import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_spikes/auth_spike.dart';
import 'package:flutter_folio/commands/books/set_current_book_command.dart';
import 'package:flutter_folio/commands/books/set_current_page_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/main_app_scaffold.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/routing/app_link.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:flutter_folio/views/auth_page/auth_page.dart';
import 'package:flutter_folio/views/home_page/home_page.dart';
import 'package:flutter_folio/views/editor_page/editor_page.dart';
import 'package:flutter_folio/views/splash_page.dart';

class AppRouterDelegate extends RouterDelegate<AppLink> with ChangeNotifier {
  final AppModel appModel;
  final BooksModel booksModel;
  final FirebaseService firebase;

  AppRouterDelegate(this.appModel, this.booksModel, this.firebase) {
    // Rebuild whenever any of our app state changes
    // When notifyListeners is called, it tells the Router to rebuild the RouterDelegate
    appModel.addListener(notifyListeners);
    booksModel.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appModel.removeListener(notifyListeners);
    booksModel.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  // Return an AppLink, representing the current app state
  AppLink get currentConfiguration => AppLink()
    ..user = firebase.userId
    ..bookId = booksModel.currentBookId
    ..pageId = booksModel.currentPageId;

  // Return a navigator, configured to match the current app state
  Widget build(BuildContext context) {
    safePrint("RouterDelegate.build()");
    // Bind to the app state we care about
    bool hasBootstrapped = appModel.hasBootstrapped;
    bool hasSetInitialRoute = appModel.hasSetInitialRoute;
    bool isGuestUser = appModel.isGuestUser;
    bool isAuthenticated = appModel.isAuthenticated;
    String currentBookId = booksModel.currentBook?.documentId;
    // Hold splash in place until our bootstrap cmd and any route parsing is done.
    bool showSplash = hasBootstrapped == false || hasSetInitialRoute == false;
    // See if we want to show a dev spike instead of the main app
    Widget devSpike = _getDevSpike();
    // Wrap
    return MainAppScaffold(
      showAppBar: showSplash == false,
      child: Navigator(
        onPopPage: _handleNavigatorPop,
        pages: [
          // Dev spike takes precedence
          if (devSpike != null) ...[
            devSpike,
          ] else if (showSplash) ...[
            SplashPage(),
          ]
          // Guest users can only see the EditView in read-only mode
          else if (isGuestUser) ...[
            BookEditorPage(bookId: currentBookId, readOnly: true),
          ]
          // Regular users
          else ...[
            // Not logged in, show auth
            if (isAuthenticated == false) ...[
              AuthPage(),
            ]
            // Logged in, show HomePage + EditPage
            else ...[
              BooksHomePage(),
              if (currentBookId != null) ...[
                BookEditorPage(bookId: currentBookId),
              ]
            ],
          ]
        ].map(_wrapContentInPage).toList(),
      ),
    );
  }

  //TODO: Fix NoAnimationsPage, SB: NoAnimationPage was rebuilding constantly when resizing the app window, not sure why.
  Page _wrapContentInPage(Widget e) {
    //On mobile, use the Material/Cupertino transitions
    // if (DeviceInfo.isMobile) {
    return MaterialPage<void>(child: e);
    // }
    // // On desktop, use no-transition as is typical
    // else {
    //   return NoAnimationPage(child: e, key: ValueKey(e.runtimeType));
    // }
  }

  //@override
  // Call once at startup of the Router, on all platforms.
  // This might hold a deeplink from the browser, or just an empty initial route "/'
  // Sample deeplink: http://localhost:8080/#/?bk=-ePtxV2wZ&pg=QZdZ1ZCIb&uid=shawn@test.com&
  Future<void> setInitialRoutePath(AppLink initialLink) async {
    if (kReleaseMode == false) {
      // Skip to some initial payload to test deeplinking
      //initialLink = AppLink(user: "shawn@test.com", bookId: "-ePtxV2wZ", pageId: "QZdZ1ZCIb");
    }
    await setNewRoutePath(initialLink);
    appModel.hasSetInitialRoute = true;
    if (kDebugMode) safePrint("setInitialRoutePath complete");
  }

  @override
  // The OS is asking us to change our location.
  // If we choose, we can update the app state to match the request from the OS.
  Future<void> setNewRoutePath(AppLink newLink) async {
    safePrint("setNewRoutePath: ${newLink.toLocation()}");

    // If we've been passed a .user that is not us, then logout, we'll enter guest mode for another user...
    if (newLink.user != null && newLink.user != appModel.currentUserEmail) {
      appModel.currentUser = null; // Logout current user
    }

    // If we're not authenticated, see if there's a userId in the link we can use..
    if (appModel.isAuthenticated == false) {
      // If we have no userId, we can't verify any links, so just bail now.
      if (newLink.user == null) return;
      // Use the userId from the deep-link to grant us read-only access to this users docs
      firebase.userId = newLink.user;
    }

    // Validate the ids that were passed in. At this point we're using either our existing authenticated user,
    // Or the guest user provided by the app link. In either case, we need to call firebase and validate the ids.
    ScrapBookData book;
    ScrapPageData page;
    if (newLink.bookId != null) {
      // Check if the bookId can be found
      book = await firebase.getBook(bookId: newLink.bookId);
      if (book != null) {
        // If the link has a pageId use that
        if (newLink.pageId != null) {
          // Check if the pageId can be found
          page = await firebase.getPage(bookId: newLink.bookId, pageId: newLink.pageId);
        }
        // Otherwise, load the first page in the book using the pageOrder value
        else if (book.pageOrder?.isNotEmpty ?? false) {
          page = await firebase.getPage(bookId: book.documentId, pageId: book.pageOrder.first);
        }
      }
    }
    // This can load a new book, or if null, send us back to the home
    SetCurrentBookCommand().run(book, setInitialPage: false);
    SetCurrentPageCommand().run(page);
  }

  //region BACK / POP Support
  // Go back one level in our state if possible
  bool tryGoBack() {
    if (booksModel.currentBook != null) {
      booksModel.currentBook = null;
      return true; //true means we handled it
    }
    return false; //false lets the whole app go into background
  }

  @override
  // Handle OS level back event  (Android mainly)
  Future<bool> popRoute() async => tryGoBack();

  // Handle Navigator.pop for any routes in our stack
  bool _handleNavigatorPop(Route<dynamic> route, dynamic result) {
    // Ask the route if it can handle pop internally...
    if (route.didPop(result)) {
      // If not, we pop one level in our stack
      return tryGoBack();
    }
    return false;
  }
  // endregion
}

Widget _getDevSpike() {
  if (kReleaseMode) return null;
  //return NativeFirebaseAuthSpike();
  //return ModelCommandsSpike();
  //return RestApiSpikes();
  //return PopupPanelSpike();
  //return TabBugRepro();
  //return FiredartStreamSpike();
  //return ButtonSheet();
  //return DraggableMenuSpike();
  //return ContextMenuSpike();
  // ignore: dead_code
  return null;
}
