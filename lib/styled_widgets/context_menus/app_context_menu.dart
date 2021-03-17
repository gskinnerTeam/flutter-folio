import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/set_current_user_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/base_context_menu.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_button.dart';
import 'package:flutter_folio/styled_widgets/context_menus/core/context_menu_card.dart';

class AppContextMenu extends BaseContextMenu {
  void _handleSignoutPressed() => SetCurrentUserCommand().run(null);
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.select((AppModel am) => am.isAuthenticated);
    return ContextMenuCard(
      children: [
        if (isLoggedIn) ...[
          ContextMenuBtn("Logout", onPressed: () => handlePressed(context, _handleSignoutPressed)),
        ],
        if (kIsWeb == false) ...[
          ContextMenuBtn("Exit Application", onPressed: () => handlePressed(context, exit(0))),
        ],
      ],
    );
  }
}
