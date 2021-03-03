import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:universal_platform/universal_platform.dart';

class LabeledTextInput extends StatefulWidget {
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
  _LabeledTextInputState createState() => _LabeledTextInputState();
}

class _LabeledTextInputState extends State<LabeledTextInput> {
  String lastValue;

  int lastPosition;

  final FocusNode rawFocus = FocusNode();

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
          if (StringUtils.isNotEmpty(widget.label)) ...[
            Text(widget.label ?? "", style: widget.labelStyle ?? TextStyles.caption),
            VSpace.med,
          ],
          TweenAnimationBuilder<double>(
            tween: Tween(begin: verticalPadding, end: verticalPadding),
            duration: Times.fast,
            curve: Curves.easeOut,
            builder: (_, animatedPaddingVt, __) {
              return RawKeyboardListener(
                focusNode: rawFocus,
                onKey: (value) {
                  lastPosition = widget.controller.selection.start;
                },
                child: TextFormField(
                  autofillHints: widget.autofillHints,
                  controller: widget.controller,
                  onChanged: UniversalPlatform.isLinux ? _fixTextOnLinux : widget.onChanged,
                  onFieldSubmitted: widget.onSubmit,
                  initialValue: widget.text,
                  style: widget.style ?? TextStyles.body2,
                  autofocus: true,
                  minLines: widget.numLines,
                  maxLines: widget.numLines,
                  obscureText: widget.obscureText ?? false,
                  decoration: InputDecoration(
                      hintText: widget.hintText ?? "",
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
              );
            },
          ),
        ],
      ),
    );
  }

  void _fixTextOnLinux(String value) {
    if (value.length > 1 && lastValue.length < value.length) {
      final enteredChar = value[0];
      final oldValue = value.substring(1);

      final prefix = oldValue.substring(0, lastPosition);
      final suffix = oldValue.substring(lastPosition);
      final newValue = prefix + enteredChar + suffix;
      widget.controller.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: lastPosition + 1),
      );
      lastValue = newValue;
      lastPosition = lastPosition + 1;
    } else {
      lastValue = value;
      lastPosition = value.length;
    }
    widget.onChanged(value);
  }
}
