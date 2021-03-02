import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/core_packages.dart';

//TODO: This is a good package / code example / blogpost
class InlineTextEditor extends StatefulWidget {
  const InlineTextEditor(this.text,
      {Key key,
      @required this.width,
      this.style,
      this.maxLines = 1,
      this.alignVertical = TextAlignVertical.center,
      this.align = TextAlign.left,
      this.onChanged,
      this.promptText,
      this.onFocusOut,
      this.onFocusIn,
      this.enableContextMenu = true,
      this.controller})
      : super(key: key);
  final double width;
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextAlignVertical alignVertical;
  final TextAlign align;
  final void Function(String value) onChanged;
  final void Function() onFocusIn;
  final void Function(String value) onFocusOut;
  final String promptText;
  final bool enableContextMenu;
  final TextEditingController controller;

  @override
  _InlineTextEditorState createState() => _InlineTextEditorState();
}

class _InlineTextEditorState extends State<InlineTextEditor> {
  bool _isEditing = false;
  TextEditingController _textController;
  FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController(text: widget.text);
    // Rebuild view when typing because we need to re-measure the height (designers want the height to grow lazily as we type)
    _textController.addListener(() => setState(() {}));
    // Listen for focus out, so we can disable editing when user clicks somewhere else
    _textFocus.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              contextMenu: GenericContextMenu(labels: ["Edit...", "Copy"], actions: [_handleTextPressed, _handleCopy]),
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
                color: Colors.red.withOpacity(.1),
                child: TextFormField(
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    onChanged: widget.onChanged,
                    style: widget.style,
                    textAlign: widget.align,
                    textAlignVertical: widget.alignVertical,
                    focusNode: _textFocus,
                    controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, bottom: 0),
                      border: InputBorder.none,
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
