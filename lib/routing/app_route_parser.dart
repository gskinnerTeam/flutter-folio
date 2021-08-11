import 'package:flutter/material.dart';
import 'package:flutter_folio/routing/app_link.dart';

/// Converts browser location strings to [AppLink], and vice-versa.
/// This leans on [AppLink] to the actual parsing, so this is largely boilerplate.
class AppRouteParser extends RouteInformationParser<AppLink> {
  @override
  // Take a url bar location, and create an AppLink from it
  Future<AppLink> parseRouteInformation(RouteInformation routeInformation) async {
    AppLink link = AppLink.fromLocation(routeInformation.location);
    //safePrint("parseRouteInfo: ${routeInformation.location} == ${link.toLocation()}");
    //safePrint("link.user=${link.user},link.pageId=${link.pageId},link.bookId=${link.bookId},");
    return link;
  }

  @override
  // Convert an applink into a string used for the browser location
  RouteInformation restoreRouteInformation(AppLink configuration) {
    // Ask the applink to give us a string
    String location = configuration.toLocation();
    //safePrint("restoreRouteInfo: $location");
    // Pass that string back to the OS so it can update the url bar
    return RouteInformation(location: location);
  }
}
