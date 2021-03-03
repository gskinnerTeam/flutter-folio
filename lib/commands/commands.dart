import 'package:flutter/material.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';
import 'package:flutter_folio/services/cloudinary/cloud_storage_service.dart';
import 'package:flutter_folio/services/firebase/firebase_service.dart';
import 'package:flutter_folio/styles.dart';
import 'package:flutter_folio/themes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
export 'package:flutter_folio/core_packages.dart';

FToast _fToast;
BuildContext _mainContext;
BuildContext get mainContext => _mainContext;

/// Someone needs to call this so our Commands can access models and services. Usually main_view.dart
void setContext(BuildContext c) {
  _mainContext = c;
  if (_fToast == null) {
    _fToast = FToast();
    _fToast.init(_mainContext);
  }
}

class BaseAppCommand {
  /// Provide quick lookups for the main Models and Services in the App.
  T getProvided<T>() {
    assert(_mainContext != null, "You must call AbstractCommand.init(BuildContext) method before calling Commands.");
    return _mainContext.read<T>();
  }

  AppTheme get appTheme => getProvided();

  FirebaseService get firebase => getProvided();
  CloudStorageService get cloudStorage => getProvided();

  AppModel get appModel => getProvided();
  BooksModel get booksModel => getProvided();

  void showToast(String content, {bool allowQueue = false}) {
    TextStyle textStyle = TextStyles.caption.copyWith(color: appModel.theme.inverseTextColor);
    if (allowQueue == false) _fToast.removeQueuedCustomToasts();
    _fToast.showToast(
      toastDuration: Duration(milliseconds: 1500),
      gravity: ToastGravity.TOP,
      child: Container(
          padding: EdgeInsets.only(top: Insets.offset),
          child: Container(
            decoration: BoxDecoration(
              color: appModel.theme.greyStrong,
              borderRadius: Corners.medBorder,
            ),
            padding: EdgeInsets.all(Insets.sm),
            child: Text(content, style: textStyle),
          )),
    );
  }
}
