import 'package:flutter/material.dart';

class AnimatedScale extends StatelessWidget {
  const AnimatedScale(
      {Key? key, required this.child, required this.end, required this.duration, this.begin, this.curve})
      : super(key: key);
  final Widget child;
  final Duration duration;
  final double? begin;
  final double end;
  final Curve? curve;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: begin ?? .2, end: end),
        curve: curve ?? Curves.easeOut,
        duration: duration,
        child: child,
        builder: (_, value, cachedChild) {
          return Transform.scale(scale: value, child: cachedChild);
        },
      );
}
