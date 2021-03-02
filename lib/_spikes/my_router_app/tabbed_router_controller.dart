import 'package:flutter/material.dart';
import 'package:flutter_folio/_spikes/controlled_router/router_controller.dart';
import 'package:flutter_folio/_spikes/my_router_app/placeholder_views.dart';

class NavState1 {
  static const settingsPageLink = "settings";
  static const profilePageLink = "profile";

  NavState1({this.selectedTab, this.topPage});
  // A tabIndex, which will control our main view stack
  final int selectedTab;
  // A fullscreen page which can (optionally) sit on top of our main tab view
  final String topPage;

  NavState1 copyWith({int selectedTab, String topPage}) {
    return NavState1(
      selectedTab: selectedTab ?? this.selectedTab,
      topPage: topPage ?? this.topPage,
    );
  }
}

class TabbedRouterController extends RouterController<NavState1> {
  TabbedRouterController(NavState1 state) : super(state);

  void showTopPage(String value) => state = state.copyWith(topPage: value);

  void changeTab(int value) => state = state.copyWith(selectedTab: value);

  @override
  List<Page> buildPages() {
    return [
      // The main view that handles switching tabs based on the .selectedTab (using Provider to bind)
      _AppPage("main", ExampleTabScaffold()),
      // Add full screen page on top of our main tab view?
      if (state.topPage == NavState1.settingsPageLink) ...[
        _AppPage(NavState1.settingsPageLink, FullScreenView("SETTINGS")),
      ] else if (state.topPage == NavState1.profilePageLink) ...[
        _AppPage(NavState1.profilePageLink, FullScreenView("SIGNUP")),
      ]
    ];
  }

  @override
  void deeplink(RouterController value) => state = value.state as NavState1;

  @override
  RouterController parseLocationSegments(List<String> segments) {
    int selectedTab = 0;
    String topPage = "";
    // Parse Segment 1 (int selectedTab)
    if (segments.length > 0) {
      selectedTab = int.tryParse(segments[0]) ?? 0;
      // Parse Segment 2 (FullScreenPageType currentFullscreenPage)
      if (segments.length > 1) {
        topPage = segments[1];
      }
    }
    return TabbedRouterController(NavState1(selectedTab: selectedTab, topPage: topPage));
  }

  @override
  List<String> getLocationSegments() {
    // Start with tabIndex `/1/`
    String loc = "/${state.selectedTab}/";
    // Add `/settings` to path?
    if (state.topPage != null) {
      loc += "//${state.topPage}/";
    }
    return loc?.split("/") ?? [];
  }

  @override
  bool goBack() {
    //Assume we'll handle the back btn
    bool wasBackHandled = true;
    // Try and close full-screen view first...
    if (state.topPage.isNotEmpty) {
      showTopPage("");
    }
    // Then go-back through the tabs until we reach 0
    else if (state.selectedTab >= 1) {
      changeTab(state.selectedTab - 1);
    } else {
      // Nowhere left to pop, indicate that we did not handle this back tap
      wasBackHandled = false;
    }
    state = state.copyWith();
    return wasBackHandled;
  }
}

class _AppPage extends MaterialPage {
  _AppPage(this.keyValue, this.child) : super(key: ValueKey(keyValue), child: child);
  final String keyValue;
  final Widget child;
}
