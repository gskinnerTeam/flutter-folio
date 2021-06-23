import 'package:flutter/material.dart';

class TabBugRepro extends StatelessWidget {
  const TabBugRepro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextButton(onPressed: () {}, child: const Text("btn")),
            Flexible(
                child: IndexedStack(
              index: 0,
              children: [
                const SomeView(),
                ExcludeFocus(
                  excluding: true,
                  child: FocusTraversalGroup(child: const SomeView()),
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
  const SomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(onPressed: () {}, child: const Text("FOO")),
      TextButton(onPressed: () {}, child: const Text("BAR")),
    ]);
  }
}
