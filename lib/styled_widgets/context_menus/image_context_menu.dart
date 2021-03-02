import 'package:flutter/material.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/base_context_menu.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_button.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_card.dart';

class ImageContextMenu extends BaseContextMenu {
  const ImageContextMenu({Key key, this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return ContextMenuCard(
      children: [
        //TODO: FileBrowser here?
        ContextMenuBtn("Save Image as..."),
      ],
    );
  }
}
