import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'linux_title_bar_icons.dart';

class _LinuxWindowButton extends WindowButton {
  _LinuxWindowButton(
      {Key? key,
      required WindowButtonColors colors,
      required WindowButtonIconBuilder iconBuilder,
      required VoidCallback onPressed})
      : super(
          key: key,
          colors: colors,
          iconBuilder: iconBuilder,
          builder: _linuxWindowButtonBuilder,
          onPressed: onPressed,
        );
}

class LinuxMinimizeButton extends _LinuxWindowButton {
  LinuxMinimizeButton({Key? key, required WindowButtonColors colors, VoidCallback? onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) => LinuxMinimizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.minimize());
}

class LinuxMaximizeButton extends _LinuxWindowButton {
  LinuxMaximizeButton({Key? key, required WindowButtonColors colors, VoidCallback? onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) => LinuxMaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

class LinuxUnmaximizeButton extends _LinuxWindowButton {
  LinuxUnmaximizeButton({Key? key, required WindowButtonColors colors, VoidCallback? onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) => LinuxUnmaximizeIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.maximizeOrRestore());
}

class LinuxCloseButton extends _LinuxWindowButton {
  LinuxCloseButton({Key? key, required WindowButtonColors colors, VoidCallback? onPressed})
      : super(
            key: key,
            colors: colors,
            iconBuilder: (buttonContext) => LinuxCloseIcon(color: buttonContext.iconColor),
            onPressed: onPressed ?? () => appWindow.close());
}

Widget _linuxWindowButtonBuilder(WindowButtonContext context, Widget icon) {
  return Container(
    margin: const EdgeInsets.all(5),
    decoration: ShapeDecoration(
      shape: const CircleBorder(),
      color: context.backgroundColor,
    ),
    child: icon,
  );
}
