import 'package:flutter/material.dart';

// Alternative to [AnimatedBuilder], same functionality but it reads better and follows the other builders (ValueListenableBuilder).
class ListenableBuilder extends AnimatedWidget {
  const ListenableBuilder({Key? key, this.child, required Listenable listenable, required this.builder})
      : super(key: key, listenable: listenable);

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
