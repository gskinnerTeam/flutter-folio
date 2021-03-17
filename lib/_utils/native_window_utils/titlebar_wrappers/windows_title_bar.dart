import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Native TitleBar for Windows, uses BitDojo platform
class WindowsTitleBar extends StatelessWidget {
  const WindowsTitleBar(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final WindowButtonColors _btnColors = WindowButtonColors(
      iconNormal: Colors.black,
      mouseOver: Colors.black.withOpacity(.2),
      mouseDown: Colors.black.withOpacity(.3),
      normal: Colors.black.withOpacity(0),
    );
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          MoveWindow(),
          child,
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MinimizeWindowButton(colors: _btnColors),
                MaximizeWindowButton(colors: _btnColors),
                CloseWindowButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
