import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer(
      {Key? key,
      this.color,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.borderRadius = 0,
      this.width,
      this.height,
      this.child})
      : super(key: key);

  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    BoxBorder? border;
    if (borderColor != null && borderWidth != 0) {
      border = Border.all(color: borderColor!, width: borderWidth);
    }
    BoxDecoration dec = BoxDecoration(color: color, border: border, borderRadius: BorderRadius.circular(borderRadius));
    return Container(decoration: dec, width: width, height: height, child: child);
  }
}
