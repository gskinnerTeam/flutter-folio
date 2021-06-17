import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
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
  // TODO: remove dependency on networking by mocking these
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
    child: AppBootstrapper(),
  ));
}
