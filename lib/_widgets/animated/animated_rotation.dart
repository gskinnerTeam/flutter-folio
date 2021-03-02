import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedRotation extends StatelessWidget {
  AnimatedRotation({
    @required this.begin,
    @required this.duration,
    @required this.child,
    this.end,
    this.curve = Curves.linear,
  });
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;

  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin ?? end, end: begin),
      builder: (context, tweenValue, _) {
        // Convert degrees to rads
        return Transform.rotate(angle: (tweenValue * pi) / 180, child: child);
      },
    );
  }
}
