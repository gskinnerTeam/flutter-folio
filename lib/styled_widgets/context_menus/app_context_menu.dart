import 'dart:io';

import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/app/set_current_user_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';

class AppContextMenu extends StatefulWidget {
  const AppContextMenu({Key? key}) : super(key: key);

  @override
  _AppContextMenuState createState() => _AppContextMenuState();
}

class _AppContextMenuState extends State<AppContextMenu> with ContextMenuStateMixin {
  void _handleSignoutPressed() => SetCurrentUserCommand().run(null);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.select((AppModel am) => am.isAuthenticated);
    return cardBuilder(
      context,
      [
        if (isLoggedIn) ...[
          buttonBuilder(context,
              ContextMenuButtonConfig("Logout", onPressed: () => handlePressed(context, _handleSignoutPressed))),
        ],
        if (kIsWeb == false) ...[
          buttonBuilder(
              context, ContextMenuButtonConfig("Exit Application", onPressed: () => handlePressed(context, exit(0)))),
        ],
      ],
    );
  }
}
