import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/debouncer.dart';
import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/_utils/safe_print.dart';
import 'package:flutter_folio/_utils/universal_file/universal_file.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:flutter_folio/themes.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class AbstractModel extends EasyNotifier {}

// * Make sure file is cleared when we logout (ChangeUserCommand)
class AppModel extends AbstractModel {
  static const kFileName = "app-model";
  static const kVersion = "1.1.3";

  // Enable "isGuestUser" if we have no current user, but firebase has been assigned a userId, and we have a current book.
  // This should cause the app to show a single scrap-board view, with read-only functionality.
  bool get isGuestUser => hasUser == false && _firebase.userId != null && _booksModel.currentBook != null;

  static bool get _defaultTouchMode => UniversalPlatform.isIOS || UniversalPlatform.isAndroid;
  static AppTheme get _defaultTheme => AppTheme.fromType(ThemeType.Orange_Light);

  AppModel(this._booksModel, this._firebase) {
    //_booksModel.addListener(notify);
  }

  // State
  Debouncer _saveDebouncer = Debouncer(Duration(seconds: 1));
  BooksModel _booksModel;
  FirebaseService _firebase;

  /// Touch Mode (show btns instead of using right-click, use larger paddings)
  bool _enableTouchMode = _defaultTouchMode;
  bool get enableTouchMode => _enableTouchMode;
  set enableTouchMode(bool value) {
    if (value == _enableTouchMode) return;
    scheduleSave();
    notify(() => _enableTouchMode = value);
  }

  void reset() {
    _currentUser = null;
    _theme = _defaultTheme;
    enableTouchMode = _defaultTouchMode;
  }

  /// Startup
  bool _hasBootstrapped = false;
  bool get hasBootstrapped => _hasBootstrapped;
  set hasBootstrapped(bool value) => notify(() => _hasBootstrapped = value);

  bool _hasSetInitialRoute = false;
  bool get hasSetInitialRoute => _hasSetInitialRoute;
  set hasSetInitialRoute(bool value) => notify(() => _hasSetInitialRoute = value);

  /// Auth
  // Current User
  AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  set currentUser(AppUser currentUser) => notify(() => _currentUser = currentUser);

  bool get isFirebaseSignedIn => _firebase.isSignedIn;

  bool get hasUser => currentUser != null;
  bool get isAuthenticated => hasUser && isFirebaseSignedIn;
  String get currentUserEmail => currentUser?.email;

  /// Settings
  // Current Theme
  AppTheme _theme = _defaultTheme;
  AppTheme get theme => _theme;
  set theme(AppTheme theme) => notify(() => _theme = theme);

  // TextDirection
  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) => notify(() => _textDirection = value);

  // Window Position
  Rect _windowRect = Rect.zero;
  Rect get windowRect => _windowRect;
  set windowRect(Rect value) {
    safePrint("Set windowRect $value");
    notify(() => _windowRect = value);
  }

  bool get hasValidWindowRect {
    return !windowRect.isEmpty &&
        windowRect.size.width > 0 &&
        windowRect.size.height > 0 &&
        windowRect.left > 0 &&
        windowRect.right > 0;
  }

  /// Public Api

  bool popNav() {
    if (_booksModel.currentBook != null) {
      _booksModel.currentBook = null;
      return true;
    }
    return false;
  }

  bool get canPopNav => _booksModel.currentBook != null;

  void scheduleSave() => _saveDebouncer.call(save);

  void save() {
    print("Saving: $kFileName");
    String saveJson = jsonEncode(toJson());
    UniversalFile(kFileName).write(saveJson);
  }

  void load() async {
    String saveJson = await UniversalFile(AppModel.kFileName).read();
    try {
      fromJson(jsonDecode(saveJson) as Map<String, dynamic>);
    } catch (e) {
      print("Failed to decode save file json: $e");
    }
    print("File loaded, $windowRect");
  }

  void fromJson(Map<String, dynamic> json) {
    _currentUser = json["currentUser"] != null ? AppUser.fromJson(json["currentUser"] as Map<String, dynamic>) : null;
    if (json["enableTouchMode"] != null) {
      _enableTouchMode = json["enableTouchMode"] as bool;
    }
    _windowRect = Rect.fromLTWH(
      json["winX"] as double ?? 0.0,
      json["winY"] as double ?? 0.0,
      json["winWidth"] as double ?? 0.0,
      json["winHeight"] as double ?? 0.0,
    );
    //print(json);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "currentUser": _currentUser?.toJson(),
      "winX": _windowRect.left,
      "winY": _windowRect.top,
      "winWidth": _windowRect.width,
      "winHeight": _windowRect.height,
      "enableTouchMode": enableTouchMode,
    };
  }
}
