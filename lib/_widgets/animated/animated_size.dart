import 'package:flutter/material.dart';

class _AnimatedSize extends StatelessWidget {
  _AnimatedSize(
      {@required this.child, @required this.duration, this.begin, @required this.end, this.curve = Curves.easeOut});
  final Widget child;
  final Duration duration;
  final Size begin;
  final Size end;
  final Curve curve;

  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Size>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin ?? end, end: end),
      builder: (context, size, _) {
        return SizedBox(width: size.width, height: size.height, child: child);
      },
    );
  }
}

class AnimatedHeight extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;

  const AnimatedHeight({
    this.child,
    @required this.duration,
    @required this.begin,
    @required this.end,
    @required this.curve,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AnimatedSize(child: child, duration: duration, begin: Size(0, begin), end: Size(0, end), curve: curve);
  }
}

class AnimatedWidth extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;

  const AnimatedWidth({
    this.child,
    @required this.duration,
    @required this.begin,
    @required this.end,
    @required this.curve,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AnimatedSize(child: child, duration: duration, begin: Size(begin, 0), end: Size(end, 0), curve: curve);
  }
}
