import 'package:flutter/foundation.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';

import 'app_model.dart';
import 'scrapboard_model.dart';

class MainAppContext {
  FirebaseService firebase;
  CloudStorageService cloudStorageService;
  AppModel_ app;
  ScrapboardModel books;

  void configure({
    @required FirebaseService firebase,
    @required CloudStorageService cloudStorageService,
    @required AppModel_ app,
    @required ScrapboardModel books,
  }) {
    this.firebase = firebase;
    this.app = app;
    this.books = books;
  }
}
