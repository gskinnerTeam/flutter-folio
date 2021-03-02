import 'package:flutter/material.dart';

import 'router_controller.dart';

// Binds the Route Parsing request from Navigator, to your own internal NavigationModel
class ControlledRouteParser<T extends RouterController> extends RouteInformationParser<RouterController> {
  ControlledRouteParser(this.controller);
  // Take an instance ofd the controller, so we can use it to parse the segments
  final T controller;

  @override
  // String >> AppDeeplink
  Future<RouterController> parseRouteInformation(RouteInformation routeInformation) async {
    List<String> segments = Uri.parse(routeInformation.location ?? "/").pathSegments;
    return controller.parseLocationSegments(segments);
  }

  @override
  // AppDeeplink >> String
  RouteInformation restoreRouteInformation(RouterController newController) {
    String location = newController.getLocationSegments().join();
    return RouteInformation(location: location);
  }
}
