import 'package:flutter/material.dart';

class PaddedRow extends StatelessWidget {
  const PaddedRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDirection = TextDirection.ltr,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline textBaseline;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    List<Widget> c = children.toList();
    Widget row = Row(
      children: c,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
    return Padding(padding: padding, child: row);
  }
}

class PaddedColumn extends StatelessWidget {
  const PaddedColumn({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDirection = TextDirection.ltr,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline textBaseline;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    List<Widget> c = children.toList();
    Widget col = Column(
      children: c,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
    return Padding(padding: padding, child: col);
  }
}
