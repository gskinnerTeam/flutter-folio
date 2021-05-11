import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/styles.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({Key? key, required this.child, this.radius}) : super(key: key);
  final Widget child;
  final double? radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 24)),
        child: child,
      );
}

class RoundedBorder extends StatelessWidget {
  const RoundedBorder({Key? key, this.color, this.width, this.radius, this.ignorePointer = true, this.child})
      : super(key: key);
  final Color? color;
  final double? width;
  final double? radius;
  final Widget? child;
  final bool ignorePointer;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignorePointer,
      child: DecoratedContainer(
        borderRadius: radius ?? Corners.med,
        borderColor: color ?? Colors.white,
        borderWidth: width ?? Strokes.thin,
        child: child ?? Container(),
      ),
    );
  }
}
