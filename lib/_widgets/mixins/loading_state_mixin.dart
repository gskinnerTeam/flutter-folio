import 'package:flutter/material.dart';

// Provides the common functionalist of having a isLoading toggle for a view, that is turned on while loading some content.
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    if (!mounted) return;
    setState(() => _isLoading = isLoading);
  }

  Future<R> load<R>(Future<R> Function() action) async {
    isLoading = true;
    R result = await action();
    isLoading = false;
    return result;
  }
}
/*
class LoadingStateMixinExample extends StatefulWidget {
  @override
  _LoadingStateMixinExampleState createState() => _LoadingStateMixinExampleState();
}

class _LoadingStateMixinExampleState extends State<LoadingStateMixinExample> with LoadingStateMixin {

  void onPress() async {
    bool result = await load(doStuffAndReturnBool);
    await load(() => doStuffAndTakeBool(false));
  }

  Future<bool> doStuffAndReturnBool() async => true;
  Future<void> doStuffAndTakeBool(bool value) async => value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          // Loading State
          ? Text("Loading...") 
          // Main Tree
          : Column(
              children: [],
            ),
    );
  }
}
*/
