import 'package:flutter/material.dart';

class SizedAndTranslated extends StatelessWidget {
  const SizedAndTranslated({
    Key? key,
    required this.size,
    required this.offset,
    required this.child,
    this.pivotPoint,
  }) : super(key: key);
  final Size size;
  final Offset offset;
  final Widget child;
  final Alignment? pivotPoint;

  @override
  Widget build(BuildContext context) {
    Alignment pivot = pivotPoint ?? const Alignment(.5, .5);
    return Transform.translate(
      offset: offset,
      child: Transform.translate(
        offset: Offset(-size.width * pivot.x, -size.height * pivot.y),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: size.width, height: size.height, child: child),
        ),
      ),
    );
  }
}
