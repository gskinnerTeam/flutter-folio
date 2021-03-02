// import '../controllers/nav_controller.dart';

// Binds the calls from Navigator, to your own internal NavigationModel
// class AppRouterDelegate extends RouterDelegate<NavState> with ChangeNotifier {
//   AppRouterDelegate(this.nav) {
//     nav.addListener((state) => notifyListeners());
//   }

//   @override
//   void dispose() {
//     nav.dispose();
//     super.dispose();
//   }

//   final NavController nav;
//   GlobalKey<NavigatorState> _navKey = GlobalKey();
//   GlobalKey<NavigatorState> get navigatorKey => _navKey;

//   // Required for the parser to get the current state and report it to the browser
//   NavState get currentConfiguration => nav.state;

//   @override
//   Future<void> setNewRoutePath(NavState value) async => nav.deeplink(value);

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//         key: navigatorKey,
//         pages: [
//           // TODO: Handle deeplink here, and skip auth if we find a valid access_key
//           if (!nav.state.isSignedIn) ...{
//             MaterialPage(child: AuthView()),
//           } else ...{
//             MaterialPage(child: TravelAppScaffold())
//           }
//         ],
//         // Handle pop(), but only for Routes that are actually in our pageStack
//         onPopPage: (route, result) {
//           bool didHandlePop = false;
//           return didHandlePop;
//         });
//   }

//   @override
//   //Handle pop event from Android
//   Future<bool> popRoute() async {
//     bool didHandlePop = false;
//     return didHandlePop;
//   }
// }
