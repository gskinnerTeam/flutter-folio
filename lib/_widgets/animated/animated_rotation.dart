import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedRotation extends StatelessWidget {
  const AnimatedRotation({
    this.begin,
    required this.end,
    required this.duration,
    required this.child,
    this.curve = Curves.linear,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final double? begin;
  final double end;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin ?? end, end: end),
      builder: (context, tweenValue, _) {
        // Convert degrees to rads
        return Transform.rotate(angle: (tweenValue * pi) / 180, child: child);
      },
    );
  }
}
