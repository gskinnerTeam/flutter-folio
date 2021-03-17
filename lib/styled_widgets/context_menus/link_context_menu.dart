import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/base_context_menu.dart';
import 'core/context_menu_button.dart';
import 'core/context_menu_card.dart';

class LinkContextMenu extends BaseContextMenu {
  const LinkContextMenu({Key? key, required this.url}) : super(key: key);
  final String url;

  String getUrl() {
    String url = this.url;
    bool needsPrefix = !url.contains("http://") && !url.contains("https://");
    return (needsPrefix) ? "https://" + url : url;
  }

  void _handleNewWindowPressed() async {
    try {
      launch(getUrl());
    } catch (e) {
      print("$e");
    }
  }

  void _handleClipboardPressed() async => Clipboard.setData(ClipboardData(text: getUrl()));

  @override
  Widget build(BuildContext context) {
    return ContextMenuCard(
      children: [
        ContextMenuBtn("Open link in new window", onPressed: () => handlePressed(context, _handleNewWindowPressed)),
        ContextMenuBtn("Copy link address", onPressed: () => handlePressed(context, _handleClipboardPressed))
      ],
    );
  }
}
