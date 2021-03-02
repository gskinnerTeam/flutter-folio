import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tabbed_router_controller.dart';

class ExampleTabScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int selectedTab = context.watch<NavState1>().selectedTab;

    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Flexible(
            child: IndexedStack(
              index: selectedTab,
              children: [
                ContentView("TAB11"),
                ContentView("TAB2"),
                ContentView("TAB3"),
              ],
            ),
          ),
          // Simple Tab Bar
          Row(
            children: [
              _TabBtn(0),
              _TabBtn(1),
              _TabBtn(2),
            ],
          )
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn(this.tabIndex, {Key key}) : super(key: key);

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    int selectedTab = context.watch<NavState1>().selectedTab;
    bool isSelected = selectedTab == tabIndex;
    TextStyle labelStyle = TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal);
    return Expanded(
      child: TextButton(
        child: Text("Tab $tabIndex", style: labelStyle),
        onPressed: () {
          context.read<TabbedRouterController>().changeTab(tabIndex);
        },
      ),
    );
  }
}

class FullScreenView extends StatelessWidget {
  const FullScreenView(this.title, {Key key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      )),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Spacer(),
            Text(title + "--", style: TextStyle(fontSize: 32)),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ContentView extends StatelessWidget {
  const ContentView(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChangePageBtn(Icons.supervised_user_circle, NavState1.profilePageLink),
              _ChangePageBtn(Icons.settings, NavState1.settingsPageLink),
              TextButton(child: Text("back"), onPressed: Navigator.of(context).pop),
            ],
          ),
          Spacer(),
          Text(title + "--", style: TextStyle(fontSize: 32)),
          Spacer(),
        ],
      ),
    );
  }
}

class _ChangePageBtn extends StatelessWidget {
  const _ChangePageBtn(this.icon, this.pageLink, {Key key}) : super(key: key);
  final String pageLink;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<TabbedRouterController>().showTopPage(pageLink);
      },
      icon: Icon(icon),
    );
  }
}
