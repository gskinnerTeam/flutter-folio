import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/core_packages.dart';

class MainAppContext {
  SPK_FirebaseService firebase;
  SPK_AppModel app;
  SPK_BooksModel books;
  SPK_PagesModel pages;

  void configure(
      {@required SPK_FirebaseService firebase,
      @required SPK_AppModel app,
      @required SPK_BooksModel books,
      @required SPK_PagesModel pages}) {
    this.firebase = firebase;
    this.app = app;
    this.books = books;
    this.pages = pages;
  }
}

class ModelCommandsSpike extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Create a app-level context so all models and services can access each-other.
    /// We could just pass a shared context, and use Provider to look eachother up, but this has limitations when using .select()
    MainAppContext appContext = MainAppContext();
    appContext.configure(
      firebase: SPK_FirebaseService(),
      app: SPK_AppModel(appContext),
      pages: SPK_PagesModel(appContext),
      books: SPK_BooksModel(appContext),
    );

    /// Provide models and services individually to the tree below,
    return MultiProvider(
        providers: [
          Provider.value(value: appContext.firebase),
          ChangeNotifierProvider.value(value: appContext.app),
          ChangeNotifierProvider.value(value: appContext.pages),
          ChangeNotifierProvider.value(value: appContext.books),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: _MainView(),
          ),
        ));
  }
}

class _MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> with AppControllersStateMixin {
  @override
  void initState() {
    super.initState();
    booksController.getStuff();
  }

  @override
  Widget build(BuildContext context) {
    String names = context.select((SPK_BooksModel m) => m.allNames);
    return Center(child: Text("Names: $names"));
  }
}

// Syntactic sugar for the views so they can access firebase a little easier
mixin AppControllersWidgetMixin {
  BooksController booksController(BuildContext c) => c.read<SPK_BooksModel>().controller;
}

mixin AppControllersStateMixin<T extends StatefulWidget> on State<T> {
  BooksController get booksController => context.read<SPK_BooksModel>().controller;
}

/// Basic controller for a model. Has a reference to the model, it's current context, and quick lookups for all the core models and services.
/// Provides syntactic sugar for all model controllers across the app, reducing their boilerplate.
abstract class AbstractModel<T> extends EasyNotifier {
  AbstractModel(this.appContext);
  final MainAppContext appContext;

  // Lazy controller creation, so we don't need to depend on a constructor
  T _controller;

  T get controller {
    if (_controller == null) {
      _controller = createController.call();
    }
    return _controller;
  }

  // Concrete models can override this to provide a custom controller
  T createController() => null;
  T get C => controller;
}

class AbstractController<T extends AbstractModel> {
  AbstractController(this.model);
  T model;

  MainAppContext get appContext => model.appContext;
}

/////////////////////////////////////////////////////////////////
/// IMPLEMENTATIONS
class SPK_FirebaseService {
  Future<String> getStuff() async {
    await Future<void>.delayed(Duration(seconds: 1));
    return "YO";
  }
}

class SPK_AppModel extends AbstractModel {
  SPK_AppModel(MainAppContext appContext) : super(appContext);
  String name = "users";
}

class SPK_PagesModel extends AbstractModel {
  SPK_PagesModel(MainAppContext appContext) : super(appContext);
  String name = "products";
}

class SPK_BooksModel extends AbstractModel<BooksController> {
  SPK_BooksModel(MainAppContext appContext) : super(appContext);

  String name = "app";
  String get allNames => appContext.pages.name + appContext.books.name;
  @override
  BooksController createController() => BooksController(this);
}

class BooksController extends AbstractController<SPK_BooksModel> {
  BooksController(SPK_BooksModel model) : super(model);

  Future<void> getStuff() async {
    print(await appContext.firebase.getStuff());
  }
}

// abstract class AbstractModel<T> {
//   // Lazy controller creation, so we don't need to depend on a constructor
//   T _controller;
//   T get api {
//     if (_controller = null) {
//       _controller = getController();
//     }
//     return _controller;
//   }
//
//   // Concrete model must provide this
//   T getController();
// }
//
// class BooksModel extends AbstractModel<BooksModelController> {
//   @override
//   BooksModelController getController() => BooksModelController(this);
//
//   List<ScrapBookData> allBooks;
// }
//
// class BooksModelController {
//   BooksModelController(this.model);
//   final BooksModel model;
// }
//
// class AppState extends ChangeNotifier {
//   int counter;
// }
//
// // Global
// (P) AppModel
// AppController
//
// (P) BooksModel
// BooksController
//
// // Book-Level
// (P) PagesModel
// PagesController
//
// (P) ScrapsModel
// ScrapsController
//
// // Page-Level
// (P) PlacedScrapsModel
// PlacedScrapsController
//
// void foo(BooksModel books) {
//
//   app.controller.authenticate()
//   app.controller.boostrap();
//   app.controller.saveWindowSize(),
//   app.controller.updateMenuBar(),
//   app.controller.setCurrentBook()
//   app.controller.setCurrentPage()
//
//   // // Books
//   books.controller.create(),
//   books.controller.refresh();
//   books.controller.refreshAll();
//   books.controller.update(),
//   books.controller.setModified();
//   books.controller.setCoverPhoto();
//   books..addToPageCount();
//   books..delete(),
//   books.selected
//   books.all
//
//   //Pages (depends on bookId)
//   pages.controller.create(),
//   pages.controller.refresh()
//   pages.controller.refreshAll();
//   pages.controller.update(),
//   pages.controller.delete(),
//   pages.selected
//   pages.all
//
//   // Scraps & Boxes  (depends on bookId)
//   scrapPile.c.create();
//   scrapPile.c.refresh();
//   scrapPile.c.update();
//   scrapPile.c.delete();
//   scrapPile.all
//
//   // Depends on bookId and pageId
//   pageScraps.actions.create();
//   pageScraps.actions.refresh();
//   pageScraps.actions.update();
//   pageScraps.actions.sendForward();
//   pageScraps.actions.moveBack();
//   pageScraps.actions.delete();
//   pageScraps.all
//   }
