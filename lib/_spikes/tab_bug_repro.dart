import 'package:flutter/material.dart';

class TabBugRepro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextButton(onPressed: () {}, child: Text("btn")),
            Flexible(
                child: IndexedStack(
              index: 0,
              children: [
                SomeView(),
                ExcludeFocus(
                  excluding: true,
                  child: FocusTraversalGroup(child: SomeView()),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class SomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(onPressed: () {}, child: Text("FOO")),
      TextButton(onPressed: () {}, child: Text("BAR")),
    ]);
  }
}
