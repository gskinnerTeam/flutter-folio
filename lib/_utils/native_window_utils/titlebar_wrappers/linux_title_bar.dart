import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';
import 'linux_title_bar_buttons.dart';

/// Native TitleBar for Linux, uses BitDojo platform
class LinuxTitleBar extends StatelessWidget {
  const LinuxTitleBar(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch();
    final WindowButtonColors btnColors = WindowButtonColors(
      iconNormal: Colors.black,
      mouseOver: Colors.black.withOpacity(.1),
      mouseDown: Colors.black.withOpacity(.2),
      normal: Colors.transparent,
    );
    final WindowButtonColors closeBtnColors = WindowButtonColors(
      normal: theme.accent1,
      iconNormal: theme.surface1,
    );

    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          MoveWindow(),
          child,
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinuxMinimizeButton(colors: btnColors),
                appWindow.isMaximized
                    ? LinuxUnmaximizeButton(colors: btnColors)
                    : LinuxMaximizeButton(colors: btnColors),
                LinuxCloseButton(colors: closeBtnColors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
