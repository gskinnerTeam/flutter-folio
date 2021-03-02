import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/core_packages.dart';

// Base class for all ContextMenus.
// Provides a handlePressed method that takes care of closing the menu after some action has been run.
abstract class BaseContextMenu extends StatelessWidget {
  const BaseContextMenu({Key key}) : super(key: key);
  // Convenience method so each menu item does not need to manually Close the context menu.
  void handlePressed(BuildContext context, VoidCallback action) {
    action?.call();
    CloseContextMenuNotification().dispatch(context);
  }
}

// Shared divider Widget
class ContextDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(color: theme.greyWeak, height: .5),
    );
  }
}
