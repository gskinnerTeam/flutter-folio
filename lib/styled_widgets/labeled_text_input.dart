import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';

class LabeledTextInput extends StatelessWidget {
  const LabeledTextInput({
    Key key,
    this.text,
    this.label,
    this.onChanged,
    this.onSubmit,
    this.style,
    this.labelStyle,
    this.numLines = 1,
    this.hintText,
    this.controller,
    this.autofillHints,
    this.obscureText,
  }) : super(key: key);

  final String label;
  final String text;
  final TextStyle style;
  final TextStyle labelStyle;
  final int numLines;
  final void Function(String value) onChanged;
  final void Function(String value) onSubmit;
  final String hintText;
  final TextEditingController controller;
  final List<String> autofillHints;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    double verticalPadding = touchMode ? Insets.lg : Insets.med;
    return Theme(
      data: theme.themeData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (StringUtils.isNotEmpty(label)) ...[
            Text(label ?? "", style: labelStyle ?? TextStyles.caption),
            VSpace.med,
          ],
          TweenAnimationBuilder<double>(
            tween: Tween(begin: verticalPadding, end: verticalPadding),
            duration: Times.fast,
            curve: Curves.easeOut,
            builder: (_, animatedPaddingVt, __) => TextFormField(
              autofillHints: autofillHints,
              controller: controller,
              onChanged: onChanged,
              onFieldSubmitted: onSubmit,
              initialValue: text,
              style: style ?? TextStyles.body2,
              autofocus: true,
              minLines: numLines,
              maxLines: numLines,
              obscureText: obscureText ?? false,
              decoration: InputDecoration(
                  hintText: hintText ?? "",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: Corners.smBorder,
                      borderSide: BorderSide(
                        color: theme.greyWeak,
                        width: 1,
                        style: BorderStyle.solid,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: Corners.smBorder,
                      borderSide: BorderSide(
                        color: theme.accent1,
                        width: 1,
                        style: BorderStyle.solid,
                      )),
                  contentPadding: EdgeInsets.only(
                    left: Insets.med,
                    right: Insets.med,
                    top: animatedPaddingVt,
                    bottom: animatedPaddingVt - 2,
                  ),
                  isDense: true),
            ),
          ),
        ],
      ),
    );
  }
}
