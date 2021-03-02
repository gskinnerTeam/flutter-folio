import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'router_controller.dart';

// Binds the calls from Navigator, to your own internal NavigationModel
class ControlledRouterDelegate<T extends RouterController> extends RouterDelegate<T> with ChangeNotifier {
  ControlledRouterDelegate(this.controller) {
    this.controller.addListener((_) => notifyListeners());
  }

  final T controller;
  GlobalKey<NavigatorState> _navKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _navKey;
  T get currentConfiguration => controller;

  @override
  Future<void> setNewRoutePath(T value) async => controller.deeplink(value);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: controller.buildPages(),
      onPopPage: (route, result) => controller.goBack(),
    );
  }

  @override
  Future<bool> popRoute() async => controller.goBack();
}
