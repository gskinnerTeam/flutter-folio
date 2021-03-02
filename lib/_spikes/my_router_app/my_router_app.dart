import 'package:flutter/material.dart';
import 'package:flutter_folio/_spikes/controlled_router/controlled_route_parser.dart';
import 'package:flutter_folio/_spikes/controlled_router/controlled_router_delegate.dart';
import 'package:flutter_folio/_spikes/my_router_app/tabbed_router_controller.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class MyRouterApp extends StatefulWidget {
  @override
  _MyRouterAppState createState() => _MyRouterAppState();
}

class _MyRouterAppState extends State<MyRouterApp> {
  // @override
  // void initState() {
  //   // Create the router controller and our initial nav state
  //   NavState initialNav = NavState(selectedTab: 0, topPage: "");
  //   // Create our navController which will handle calls from the RouterDelegate and RouteInformationParser
  //   controller = TabbedRouterController(initialNav);
  //   super.initState();
  // }

  TabbedRouterController controller = TabbedRouterController(
    NavState1(selectedTab: 0, topPage: ""),
  );

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<TabbedRouterController, NavState1>.value(
      value: controller,
      child: MaterialApp.router(
        routeInformationParser: ControlledRouteParser(controller),
        routerDelegate: ControlledRouterDelegate(controller),
      ),
    );
  }
}
