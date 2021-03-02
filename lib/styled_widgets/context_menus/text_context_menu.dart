import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';

import 'core/base_context_menu.dart';
import 'core/context_menu_button.dart';
import 'core/context_menu_card.dart';

class TextContextMenu extends BaseContextMenu {
  const TextContextMenu({Key key, @required this.data, this.controller, this.obscuredText = false}) : super(key: key);
  final String data;
  final TextEditingController controller;
  final bool obscuredText;

  void _handleCopyPressed() async {
    String value = controller == null ? data : controller.selection.textInside(data);
    Clipboard.setData(ClipboardData(text: value));
  }

  void _handleDeletePressed() async => controller.clear();

  void _handleSelectAllPressed() async {
    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }

  void _handlePastePressed() async {
    int start = controller.selection.start;
    removeTextRange(controller.selection.start, controller.selection.end);
    String value = (await Clipboard.getData("text/plain")).text;
    addTextAtOffset(controller.selection.start, value);
    // Move cursor to end on paste, as one does on desktop :)
    controller.selection = TextSelection.fromPosition(TextPosition(offset: start + value.length));
  }

  void _handleCutPressed() async {
    // Remove selected section, insert new selection at offset
    int start = controller.selection.start;
    int end = controller.selection.end;
    //Copy content
    String content = controller.text.substring(start, end);
    Clipboard.setData(ClipboardData(text: content));
    //Remove content
    removeTextRange(start, end);
  }

  void addTextAtOffset(int start, String value) {
    String p1 = controller.text.substring(0, start);
    String p2 = controller.text.substring(start);
    controller.text = p1 + value + p2;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: start + value.length));
  }

  void removeTextRange(int start, int end) {
    String p1 = controller.text.substring(0, start);
    String p2 = controller.text.substring(end);
    controller.text = p1 + p2;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: start));
  }

  @override
  Widget build(BuildContext context) {
    bool allSelected = false, noneSelected = true;
    if (controller != null) {
      controller?.value?.selection == TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      noneSelected = controller?.value?.selection?.isCollapsed ?? true;
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

extension TextContextExtension on Text {
  Widget addContextMenu(String data) {
    return ContextMenuRegion(
      contextMenu: TextContextMenu(data: data),
      child: this,
    );
  }
}

extension TextFormFieldContextExtension on TextFormField {
  Widget addContextMenu(String data, {TextEditingController controller, bool obscuredText = false}) {
    return ContextMenuRegion(
      contextMenu: TextContextMenu(data: data, controller: controller, obscuredText: obscuredText),
      child: this,
    );
  }
}
