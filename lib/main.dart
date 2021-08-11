import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/logger.dart';
import 'package:flutter_folio/commands/app/bootstrap_command.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/routing/app_route_parser.dart';
import 'package:flutter_folio/routing/app_router.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:flutter_folio/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  // Call a method to setup a global error handler so we can log all errors, including ones from native extensions.
  initLogger(() async {
    // Status bar style on Android/iOS
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());

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
      child: const AppBootstrapper(),
    ));
  });
}

// Bootstrap the app, initializing all Controllers and Services
class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({Key? key}) : super(key: key);

  @override
  _AppBootstrapperState createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  AppRouteParser routeParser = AppRouteParser();
  late AppRouterDelegate router;
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
    // Get the current AppTheme so we can generate a ThemeData for the MaterialApp
    AppTheme theme = context.select((AppModel m) => m.theme);
    // TODO-SNIPPET: Using visual density
    // Generate ThemeData from our own custom AppTheme object
    ThemeData materialTheme = theme.toThemeData();
    // Determine the density we want, based on AppModel.enableTouchMode
    bool enableTouchMode = context.select((AppModel m) => m.enableTouchMode);
    double density = enableTouchMode ? 0 : -1;
    print("enableTouchMode: $enableTouchMode");
    // Inject desired density into MaterialTheme for free animation when values change
    materialTheme = ThemeData(visualDensity: VisualDensity(horizontal: density, vertical: density));
    return MaterialApp.router(
      title: "Flutter Folio",
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      // Use a custom route/delegate to change navigation // TODO: Replace with VRouter/NavStack
      routeInformationParser: routeParser,
      routerDelegate: router,
    );
  }
}
