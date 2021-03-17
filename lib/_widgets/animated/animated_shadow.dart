import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedShadow extends StatelessWidget {
  AnimatedShadow({
    Key? key,
    required this.child,
    required this.duration,
    required this.blurs,
    required this.colors,
    this.begin,
    required this.end,
    this.curve,
  }) : super(key: key) {
    assert(blurs.length == colors.length, "blurs.length and colors.length must match");
  }

  final Widget child;
  final Duration duration;
  final double? begin;
  final double end;
  final List<double> blurs;
  final List<Color> colors;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin ?? end, end: end),
      curve: curve ?? Curves.easeOut,
      builder: (_, double value, _child) {
        return Container(
          decoration: BoxDecoration(boxShadow: [
            ...blurs.map((b) {
              Color c = colors[blurs.indexOf(b)];
              // Like a real shadow, it blurs more when raised, but the strength actually goes down
              return BoxShadow(
                blurRadius: max(0, b * value),
                color: c.withOpacity(value < .1 ? 0 : max(0, 1 - (value * (1 - c.opacity)))),
              );
            })
          ]),
          child: _child,
        );
      },
      child: child,
      duration: duration,
    );
  }
}
