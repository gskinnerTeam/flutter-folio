// @dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/base_context_menu.dart';
import 'core/context_menu_button.dart';
import 'core/context_menu_card.dart';

class TextContextMenu extends BaseContextMenu {
  const TextContextMenu({Key? key, required this.data, this.controller, this.obscuredText = false}) : super(key: key);
  final String data;
  final TextEditingController? controller;
  final bool obscuredText;

  void _handleCopyPressed() async {
    String value = controller?.selection.textInside(data) ?? data;
    Clipboard.setData(ClipboardData(text: value));
  }

  void _handleDeletePressed() async => controller?.clear();

  void _handleSelectAllPressed() async {
    controller?.selection = TextSelection(baseOffset: 0, extentOffset: controller?.text.length ?? 0);
  }

  void _handlePastePressed() async {
    final c = controller;
    if (c == null) return;
    int start = c.selection.start;
    removeTextRange(c.selection.start, c.selection.end);
    String? value = (await Clipboard.getData("text/plain"))?.text;
    if (value != null) {
      addTextAtOffset(c.selection.start, value);
      // Move cursor to end on paste, as one does on desktop :)
      c.selection = TextSelection.fromPosition(TextPosition(offset: start + value.length));
    }
  }

  void _handleCutPressed() async {
    final c = controller;
    if (c == null) return;
    // Remove selected section, insert new selection at offset
    int start = c.selection.start;
    int end = c.selection.end;
    //Copy content
    String content = c.text.substring(start, end);
    Clipboard.setData(ClipboardData(text: content));
    //Remove content
    removeTextRange(start, end);
  }

  void addTextAtOffset(int start, String value) {
    final c = controller;
    if (c == null) return;
    String p1 = c.text.substring(0, start);
    String p2 = c.text.substring(start);
    c.text = p1 + value + p2;
    c.selection = TextSelection.fromPosition(TextPosition(offset: start + value.length));
  }

  void removeTextRange(int start, int end) {
    if (controller == null) return;
    String p1 = controller!.text.substring(0, start);
    String p2 = controller!.text.substring(end);
    controller!.text = p1 + p2;
    controller!.selection = TextSelection.fromPosition(TextPosition(offset: start));
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = false, noneSelected = true;
    final c = controller;
    if (c != null) {
      c.value.selection == TextSelection(baseOffset: 0, extentOffset: c.text.length);
      noneSelected = c.value.selection.isCollapsed;
    }
    bool disableCopy = noneSelected || obscuredText;
    bool disableCut = noneSelected || obscuredText;
    bool disablePaste = obscuredText;
    bool disableDelete = noneSelected;
    bool disableSelectAll = allSelected || data.isEmpty;
    return ContextMenuCard(
      children: [
        ContextMenuBtn("Copy", onPressed: disableCopy ? null : () => handlePressed(context, _handleCopyPressed)),
        if (controller != null) ...[
          ContextDivider(),
          if (!obscuredText) ...[
            ContextMenuBtn("Cut", onPressed: disableCut ? null : () => handlePressed(context, _handleCutPressed)),
            ContextMenuBtn("Paste", onPressed: disablePaste ? null : () => handlePressed(context, _handlePastePressed)),
          ],
          ContextMenuBtn("Delete",
              onPressed: disableDelete ? null : () => handlePressed(context, _handleDeletePressed)),
          ContextDivider(),
          ContextMenuBtn("Select All",
              onPressed: disableSelectAll ? null : () => handlePressed(context, _handleSelectAllPressed)),
        ]
      ],
    );
  }
}

class Foo extends StatelessWidget {
  const Foo({Key? key, this.value}) : super(key: key);
  final String? value;

  @override
  Widget build(BuildContext context) {
    return (value == null) ? Container() : Text(value!);
  }
}

class Bar extends Foo {
  @override
  String? get value => null;
}
