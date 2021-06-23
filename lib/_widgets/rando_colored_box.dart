import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class RandoColoredBox extends StatelessWidget {
  const RandoColoredBox({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: RandomColor().randomColor(colorBrightness: ColorBrightness.light),
      child: child,
    );
  }
}
