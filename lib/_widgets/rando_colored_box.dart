//dart 2.9
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class RandoColoredBox extends StatelessWidget {
  const RandoColoredBox({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RandomColor().randomColor(colorBrightness: ColorBrightness.light),
      child: child,
    );
  }
}
