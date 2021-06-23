import 'package:flutter/material.dart';

class NoAnimationPage extends Page {
  final Widget child;
  const NoAnimationPage({required this.child, LocalKey? key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        maintainState: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        settings: this,
        pageBuilder: (context, animation, animation2) => child);
  }
}
