import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/core_packages.dart';

//TODO: This is a good package / code example / blogpost
class InlineTextEditor extends StatefulWidget {
  const InlineTextEditor(this.text,
      {Key? key,
      required this.width,
      required this.style,
      this.maxLines = 1,
      this.alignVertical = TextAlignVertical.center,
      this.align = TextAlign.left,
      this.onChanged,
      this.promptText,
      this.onFocusIn,
      this.onFocusOut,
      this.controller,
      this.enableContextMenu = true,
      this.autoFocus = false,
      this.maxLength})
      : super(key: key);
  final double width;
  final String text;
  final int maxLines;
  final int? maxLength;
  final bool autoFocus;
  final TextAlignVertical alignVertical;
  final TextAlign align;
  final TextStyle style;
  final void Function(String value)? onChanged;
  final String? promptText;
  final void Function()? onFocusIn;
  final void Function(String value)? onFocusOut;
  final TextEditingController? controller;
  final bool enableContextMenu;

  @override
  _InlineTextEditorState createState() => _InlineTextEditorState();
}

class _InlineTextEditorState extends State<InlineTextEditor> {
  bool _isEditing = false;
  late TextEditingController _textController;
  final FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController(text: widget.text);
    // Rebuild view when typing because we need to re-measure the height (designers want the height to grow lazily as we type)
    _textController.addListener(() => setState(() {}));
    // Listen for focus out, so we can disable editing when user clicks somewhere else
    _textFocus.addListener(_handleFocusChanged);
    if (widget.autoFocus) {
      _isEditing = true;
      _textFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    // Only dispose our internal controller
    if (_textController != widget.controller) {
      _textController.dispose();
    }
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    // Measure Size of text using a maxWidth and maxLines so we can reserve a space of that size
    String textToMeasure = _textController.text;
    Size textSize = StringUtils.measure(textToMeasure, widget.style, maxLines: widget.maxLines, maxWidth: widget.width);
    // Tweak to stop text from shifting, TextFormField seems to add a cpl pixels worth of padding.
    double extraWidth = _isEditing ? 3 : 0;
    double extraHeight = _isEditing ? 12 : 0;
    bool usePromptText = StringUtils.isEmpty(_textController.text);
    //print(_textController.text);
    return Container(
      width: widget.width + extraWidth,
      height: textSize.height + extraHeight,
      alignment: Alignment(-1, widget.alignVertical.y),
      child: Stack(
        children: [
          if (!_isEditing) ...[
            // Show a right-click menu to copy the text just because we can :D
            ContextMenuRegion(
              isEnabled: widget.enableContextMenu,
              contextMenu: GenericContextMenu(
                buttonConfigs: [
                  ContextMenuButtonConfig("Edit...", onPressed: _handleTextPressed),
                  ContextMenuButtonConfig("Copy", onPressed: _handleCopy),
                ],
              ),
              // Wrap the text in a button, so we can switch to editing mode when they click.
              child: SimpleBtn(
                onPressed: _handleTextPressed,
                child: SizedBox(
                  width: widget.width,
                  child: Opacity(
                    opacity: usePromptText ? .6 : 1,
                    child: Text(
                      StringUtils.isEmpty(_textController.text) ? (widget.promptText ?? "") : _textController.text,
                      style: widget.style,
                      textAlign: widget.align,
                      maxLines: widget.maxLines,
                      overflow: TextOverflow.clip,
                      softWrap: widget.maxLines == 1 ? false : true,
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            ContextMenuRegion(
              isEnabled: widget.enableContextMenu,
              contextMenu: TextContextMenu(data: _textController.text, controller: _textController),
              child: Container(
                color: theme.accent1.withOpacity(.1),
                child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    onChanged: widget.onChanged,
                    style: widget.style,
                    textAlign: widget.align,
                    textAlignVertical: widget.alignVertical,
                    focusNode: _textFocus,
                    cursorColor: theme.grey,
                    controller: _textController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, bottom: 0),
                      border: InputBorder.none,
                      counterText: "",
                      isDense: true,
                    ),
                    minLines: widget.maxLines,
                    maxLines: widget.maxLines),
              ),
            ),
          ]
        ],
      ),
    );
  }

  void _handleCopy() => Clipboard.setData(ClipboardData(text: _textController.text));

  // Ends editing mode when the user focuses out of the text box
  void _handleFocusChanged() {
    if (_textFocus.hasFocus == false) {
      setState(() => _isEditing = false);
      widget.onFocusOut?.call(_textController.text);
    } else {
      widget.onFocusIn?.call();
    }
    InlineTextEditorFocusNotification(_textFocus.hasFocus).dispatch(context);
  }

  // Switches to editing mode
  void _handleTextPressed() {
    setState(() => _isEditing = true);
    //_textController.selection = TextSelection(baseOffset: 0, extentOffset: _textController.text.length);
    _textFocus.requestFocus();
  }
}

class InlineTextEditorFocusNotification extends Notification {
  InlineTextEditorFocusNotification(this.hasFocus);
  final bool hasFocus;
}
