import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/commands/app/bootstrap_command.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/routing/app_route_parser.dart';
import 'package:flutter_folio/routing/app_router.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  //Call this first to make sure we can make other system level calls safely
  WidgetsFlutterBinding.ensureInitialized();
  // Status bar style on Android/iOS
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());

  if (kIsWeb) {
    // Increase Skia cache size to support bigger images.
    const int megabyte = 1000000;
    SystemChannels.skia.invokeMethod('Skia.setResourceCacheMaxBytes', 512 * megabyte);
    // TODO: cant' await on invokeMethod due to https://github.com/flutter/flutter/issues/77018  so awaiting on Future.delayed instead.
    await Future<void>.delayed(Duration.zero);
  }

  /// Create core models & services
  FirebaseService firebase = FirebaseFactory.create();
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

    //child: BasicRouterSpike(),
    child: _AppBootstrapper(),
  ));
  //
}

// Bootstrap the app, initializing all Controllers and Services
class _AppBootstrapper extends StatefulWidget {
  @override
  _AppBootstrapperState createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<_AppBootstrapper> {
  AppRouteParser routeParser = AppRouteParser();
  AppRouterDelegate router;
  @override
  void initState() {
    // Create the appRouter, and inject it with the models/services it needs
    router = AppRouterDelegate(
      context.read<AppModel>(),
      context.read<BooksModel>(),
      context.read<FirebaseService>(),
    );
    // Run Bootstrap with scheduleMicrotask to avoid triggering any builds from init(), which would throw an error.
    scheduleMicrotask(() {
      // Bootstrap. This will initialize services, load saved data, determine initial navigation state and anything else that needs to get done at startup
      BootstrapCommand().run(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Convert appState to (and from) a string "location"
      routeInformationParser: routeParser,
      // Builds a stack that represents your appState.
      routerDelegate: router,
      // Disable debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
