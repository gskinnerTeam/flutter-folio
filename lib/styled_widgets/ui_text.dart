// @dart=2.12
import 'package:flutter/material.dart';

// Extends SelectableText, providing default web-like behavior of a non-focuseable but selectable text region
class UiText extends StatelessWidget {
  const UiText(this.data, {Key? key, this.style}) : super(key: key);
  final String? data;
  final TextStyle? style;

  static Widget rich(TextSpan span, {TextStyle? style}) {
    return ExcludeFocus(
      excluding: true,
      child: SelectableText.rich(span, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(data ?? "", style: style, focusNode: FocusNode(skipTraversal: true));
  }
}
