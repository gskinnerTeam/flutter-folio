import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_folio/core_packages.dart';

class AnimatedMenuPanel extends StatefulWidget {
  const AnimatedMenuPanel(
    this.closedPos,
    this.closedSize, {
    Key? key,
    required this.openHeight,
    required this.isOpen,
    this.isVisible = true,
    this.onPressed,
    required this.childBuilder,
  }) : super(key: key);
  final Offset closedPos;
  final Size closedSize;
  final double openHeight;
  final bool isOpen;
  final VoidCallback? onPressed;
  final bool isVisible;
  final Widget Function(bool isOpen) childBuilder;

  @override
  _AnimatedMenuPanelState createState() => _AnimatedMenuPanelState();
}

class _AnimatedMenuPanelState extends State<AnimatedMenuPanel> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        Size s = constraints.biggest;
        // Figure out padding, depending on whether we're open or not.
        EdgeInsets closedPadding = EdgeInsets.only(
          top: widget.closedPos.dy,
          bottom: max(0, s.height - (widget.closedPos.dy + widget.closedSize.height)),
          left: widget.closedPos.dx,
          right: s.width - widget.closedPos.dx - widget.closedSize.width,
        );
        EdgeInsets openPadding = EdgeInsets.only(bottom: s.height - widget.openHeight);

        /// Fade out when not visible
        return AnimatedOpacity(
          duration: widget.isVisible ? Times.fastest : Times.fast,
          opacity: widget.isVisible ? 1 : 0,

          /// Ignore pointer when not visible
          child: IgnorePointer(
            ignoring: widget.isVisible == false,

            /// Change padding depending on whether we're open or not
            child: AnimatedContainer(
              curve: Curves.easeOutCubic,
              padding: (widget.isOpen) ? openPadding : closedPadding,
              duration: Times.medium,

              /// Proxy pressed call to listeners
              child: GestureDetector(
                  onTap: widget.onPressed,

                  /// Content
                  child: widget.childBuilder.call(widget.isOpen)),
            ),
          ),
        );
      },
    );
  }
}
