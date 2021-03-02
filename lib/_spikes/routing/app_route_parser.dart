// import '../controllers/nav_controller.dart';

// Binds the Route Parsing request from Navigator, to your own internal NavigationModel
// class AppRouteParser extends RouteInformationParser<NavState> {
//   @override
//   // String >> AppState
//   Future<NavState> parseRouteInformation(RouteInformation routeInformation) async {
//     List<String> segments = Uri.parse(routeInformation.location ?? "/home").pathSegments;
//     return NavState();
//   }

//   @override
//   // AppState >> String
//   RouteInformation restoreRouteInformation(NavState state) {
//     String location = "";
//     if (state.tripId != null) {
//       location += "/trip/${state.tripId}";
//       if (state.eventId != null) {
//         location += "/event/${state.eventId}";
//       }
//     }
//     return RouteInformation(location: location);
//   }
// }
