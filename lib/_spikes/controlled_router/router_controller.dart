import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

// Alternate Approach: If we create our own RouterDelegate, and just declare static methods for InformationParsing, that effectively combines them.
// Is the answer just to say that your Delegate is your model? It holds the state, it works on everything? This makes sense, but it's hard to integrate into an existing app that has existing state.
// How is this any better than just declaring the Router and RouteInformationParser in one class?
//  A: It simplifies the footprint, because there are a lot of moving parts with the raw delegate. For most people, 5 methods is all they need.
//  A:  It does the basic wiring between stats and delegate, and has an opinion about the state you should use (ChangeNotifier). Errors here are a very common pain point.
// On the downside, this is abstraction on top of an already complex system.
// In some sense, it reverses the abstraction layers, boiling them back down, but it is still another layer.
// Need to play more to decide...

//NOTE: This is WIP, and currently has issues.

// A base class to use for your app navigation model and routing logic.
// It is a light abstraction on top of Router, and works with 2 helper classes [ControlledRouterDelegate] and [ControledInformationParser]
// These helper classes are proxies, that pass their methods here.
// This combines 3 files into 1 (RouterDelegate + RouteInformationParser + MyNavigationState)
// Goals:
//  * Reduce learning curve for developers by promoting code-locality.
//    * Groups all of the API's for RouterDelegate and RouterParser into one place
//    * Devs need only implement a single class, and they can also hold their state there, which is
//    * Reduce cognitive load by combining everything in one, usually rather small, class.
//    * Avoid learning implementation details of Router, focus on the code that needs to be written (while retaining full control)
//  * Let the state live with the methods that work on the state, as a typical model does
//  * Reduce some common errors by handling binding boilerplate between state and delegate
abstract class RouterController<T> extends StateNotifier<T> {
  RouterController(T state) : super(state);

  // Back support - Move back/up one level in your state object
  bool goBack();

  // Deeplink, update app state to match the new value
  void deeplink(RouterController controller);

  // Return a list of Page Widgets based on the current state
  List<Page> buildPages();

  // Convert Location string to State, and vice-versa
  //eg, "[1][settings]" ===> { tabIndex: 1, page: settings }
  List<String> getLocationSegments();
  RouterController parseLocationSegments(List<String> segments);
}
