import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({
    Key? key,
    this.color,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.width,
    this.height,
    this.child,
    this.ignorePointer = false,
    this.shadows,
    this.clipChild = false,
    this.padding,
    this.alignment,
  }) : super(key: key);

  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Widget? child;
  final bool ignorePointer;
  final List<BoxShadow>? shadows;
  final bool clipChild;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    // Create border if we have both a color and width
    BoxBorder? border;
    if (borderColor != null && borderWidth != 0) {
      border = Border.all(color: borderColor!, width: borderWidth);
    }
    // Create decoration
    BoxDecoration dec = BoxDecoration(
      color: color,
      border: border,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows,
    );

    // Optionally wrap the content in a clipper that matches border radius
    return IgnorePointer(
      ignoring: ignorePointer,
      child: Container(
        decoration: dec,
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        child: clipChild
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: child,
              )
            : child,
      ),
    );
  }
}
