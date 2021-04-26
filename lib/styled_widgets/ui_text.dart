import 'package:flutter/material.dart';

// Extends SelectableText, providing default web-like behavior of a non-focuseable but selectable text region
class UiText extends StatelessWidget {
  const UiText(this.data, {Key? key, this.style}) : super(key: key);
  final String? data;
  final TextStyle? style;

  static FocusNode getFocusNode() => FocusNode(skipTraversal: true);

  static Widget rich(TextSpan span, {TextStyle? style}) {
    return SelectableText.rich(span, style: style, focusNode: getFocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(data ?? "", style: style, focusNode: getFocusNode());
  }
}
