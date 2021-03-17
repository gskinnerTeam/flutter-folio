import 'package:flutter/material.dart';

// Has a notify() method that reduces boilerplate in ChangeNotifiers, similar to setState((){}) in a StatefulWidget;
// Also allows external .notify() calls, being un-opinionated about whether this is called externally.
class EasyNotifier extends ChangeNotifier {
  void notify([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}
