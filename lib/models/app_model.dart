import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/device_info.dart';
import 'package:flutter_folio/_utils/easy_notifier.dart';
import 'package:flutter_folio/_utils/universal_file/universal_file.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:flutter_folio/themes.dart';

import '../_utils/timed/debouncer.dart';

abstract class AbstractModel extends EasyNotifier {}

// * Make sure file is cleared when we logout (ChangeUserCommand)
class AppModel extends AbstractModel {
  static const kFileName = "app-model";
  static const kVersion = "1.2.3";

  // Determines what the start value should be for touchMode, bases on the current device os
  static bool defaultToTouchMode() => DeviceOS.isMobile;

  static AppTheme get _defaultTheme => AppTheme.fromType(ThemeType.Orange_Light);

  AppModel(this._booksModel, this._firebase) {
    //_booksModel.addListener(notify);
  }

  // State
  final Debouncer _saveDebouncer = Debouncer(const Duration(seconds: 1));
  final BooksModel _booksModel;
  final FirebaseService _firebase;

  /// Touch Mode (show btns instead of using right-click, use larger paddings)
  bool _enableTouchMode = defaultToTouchMode();
  bool get enableTouchMode => _enableTouchMode;
  set enableTouchMode(bool value) {
    if (value == _enableTouchMode) return;
    scheduleSave();
    notify(() => _enableTouchMode = value);
  }

  void reset() {
    _currentUser = null;
    _theme = _defaultTheme;
    enableTouchMode = defaultToTouchMode();
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
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  set currentUser(AppUser? currentUser) => notify(() => _currentUser = currentUser);

  bool get isFirebaseSignedIn => _firebase.isSignedIn;

  bool get hasUser => currentUser != null;
  bool get isAuthenticated => hasUser && isFirebaseSignedIn;
  String? get currentUserEmail => currentUser?.email;

  // Enable "isGuestUser" if we have no current user, but firebase has been assigned a userId, and we have a current book.
  // This should cause the app to show a single scrap-board view, with read-only functionality.
  bool get isGuestUser => hasUser == false && _firebase.userId != null && _booksModel.currentBook != null;

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
  Size windowSize = Size.zero;

  /// Public Api

  bool popNav() {
    if (_booksModel.currentBook != null) {
      _booksModel.currentBook = null;
      return true;
    }
    return false;
  }

  void scheduleSave() => _saveDebouncer.run(save);

  Future<void> save() async {
    print("Saving: $kFileName");
    String saveJson = jsonEncode(toJson());
    await UniversalFile(kFileName).write(saveJson);
  }

  Future<void> load() async {
    String? saveJson = await UniversalFile(AppModel.kFileName).read();
    if (saveJson != null) {
      try {
        fromJson(jsonDecode(saveJson) as Map<String, dynamic>);
        print("Save file loaded, $windowSize");
      } catch (e) {
        print("Failed to decode save file json: $e");
      }
    } else {
      print("No save file found.");
    }
  }

  void fromJson(Map<String, dynamic> json) {
    _currentUser = json["currentUser"] != null ? AppUser.fromJson(json["currentUser"] as Map<String, dynamic>) : null;
    if (json["enableTouchMode"] != null) {
      _enableTouchMode = json["enableTouchMode"] as bool;
    }
    windowSize = Size(
      json["winWidth"] as double? ?? 0.0,
      json["winHeight"] as double? ?? 0.0,
    );
    //print(json);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "currentUser": _currentUser?.toJson(),
      "winWidth": windowSize.width,
      "winHeight": windowSize.height,
      "enableTouchMode": enableTouchMode,
    };
  }
}
