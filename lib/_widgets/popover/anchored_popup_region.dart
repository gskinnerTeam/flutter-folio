import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/safe_print.dart';
import 'package:flutter_folio/styled_widgets/buttons/styled_buttons.dart';

import 'anchored_popups.dart';

enum PopUpMode {
  ClickToToggle, // Click a region to open PopOver, click barrier to close.
  Hover, // Open on hoverIn (slightly delayed), close on hoverOut
}

class AnchoredPopUpRegion extends StatefulWidget {
  AnchoredPopUpRegion(
      {Key? key,
      required this.child,
      required this.popChild,
      this.anchor,
      this.popAnchor,
      this.barrierDismissable,
      this.barrierColor,
      required this.mode})
      : super(key: key);
  final Widget child;
  final Widget popChild;
  final bool? barrierDismissable;
  final Color? barrierColor;
  final Alignment? anchor;
  final Alignment? popAnchor;
  final PopUpMode mode;
  @override
  AnchoredPopUpRegionState createState() => AnchoredPopUpRegionState();

  // Non-interactive tool-tips, triggered on a delayed hover. Auto-close when you roll-out of the PopOverRegion
  static AnchoredPopUpRegion hover(
      {Key? key, required Widget child, required Widget popChild, Alignment? anchor, Alignment? popAnchor}) {
    return AnchoredPopUpRegion(
        key: key, child: child, popChild: popChild, anchor: anchor, popAnchor: popAnchor, mode: PopUpMode.Hover);
  }

  // Click to open/close. Use for interactive panels, or other elements that should close themselves
  static AnchoredPopUpRegion click(
      {Key? key,
      required Widget child,
      required Widget popChild,
      Alignment? anchor,
      Alignment? popAnchor,
      bool? barrierDismissable,
      Color? barrierColor}) {
    return AnchoredPopUpRegion(
      key: key,
      child: child,
      popChild: popChild,
      anchor: anchor,
      popAnchor: popAnchor,
      mode: PopUpMode.ClickToToggle,
      barrierColor: barrierColor,
      barrierDismissable: barrierDismissable,
    );
  }

  static AnchoredPopUpRegion hoverWithClick({
    Key? key,
    required Widget child,
    required Widget hoverPopChild,
    required Widget clickPopChild,
    bool barrierDismissable = true,
    Color? barrierColor,
    Alignment? hoverAnchor,
    Alignment? hoverPopAnchor,
    Alignment? clickAnchor,
    Alignment? clickPopAnchor,
  }) {
    return click(
        key: key,
        anchor: clickAnchor,
        barrierColor: barrierColor,
        barrierDismissable: barrierDismissable,
        popChild: clickPopChild,
        popAnchor: clickPopAnchor,
        child: hover(popAnchor: hoverPopAnchor, popChild: hoverPopChild, anchor: hoverAnchor, child: child));
  }
}

class AnchoredPopUpRegionState extends State<AnchoredPopUpRegion> {
  Timer? _timer;
  LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    Widget content;
    // If Hover, add a MouseRegion
    if (widget.mode == PopUpMode.Hover) {
      content = MouseRegion(
        opaque: true,
        onEnter: (_) => _handleHoverStart(),
        onExit: (_) => _handleHoverEnd(),
        child: widget.child,
      );
    } else {
      content = SimpleBtn(onPressed: show, child: widget.child);
    }
    return CompositedTransformTarget(link: _link, child: content);
  }

  @override
  void dispose() {
    if (widget.mode == PopUpMode.Hover) {
      _handleHoverEnd();
    }
    super.dispose();
  }

  void show() {
    if (mounted == false) {
      safePrint("PopoverRegion: Exiting early not mounted anymore");
      return;
    }
    safePrint("PopoverRegion: Sending notification...");
    AnchoredPopups.of(context)?.show(context,
        popChild: widget.popChild,
        anchor: widget.anchor ?? Alignment.bottomCenter,
        popAnchor: widget.popAnchor ?? Alignment.topCenter,
        // Don't use a barrier at all when using Hover mode
        useBarrier: widget.mode != PopUpMode.Hover,
        barrierColor: widget.barrierColor ?? Colors.transparent,
        dismissOnBarrierClick: widget.barrierDismissable ?? true);
  }

  void _handleHoverStart() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 400), (_) {
      safePrint("PopoverRegion: Show!");
      show();
      _timer?.cancel();
    });
  }

  void _handleHoverEnd() {
    _timer?.cancel();
    AnchoredPopupsController? popups = AnchoredPopups.of(context);
    // before hiding, make sure we haven't been replaced with some other popup.
    bool isStillOpen = popups?.currentPopup?.context == context;
    if (isStillOpen) {
      popups?.hide();
    }
  }
}
