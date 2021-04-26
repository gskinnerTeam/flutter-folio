import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/safe_print.dart';
import 'package:flutter_folio/styled_widgets/buttons/styled_buttons.dart';

import 'popover_controller.dart';
import 'popover_notifications.dart';

/// //////////////////////////////////
/// POPOVER REGION
///
/// 2 Modes,
/// Simple roll-over mode,
///   - the Underlay is not shown... instead, a MouseRegion is added
/// Clickable-mode
///   - underlay is shown
///   - barrierDismissable is an option
///
///
///
///
enum PopOverRegionMode {
  ClickToToggle, // Click a region to open PopOver, click barrier to close.
  Hover, // Open on hoverIn (slightly delayed), close on hoverOut
  Toast, // Shows a non-interactive tooltip and fades it out after some time
}

class PopOverRegion extends StatefulWidget {
  PopOverRegion(
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
  final PopOverRegionMode mode;
  @override
  PopOverRegionState createState() => PopOverRegionState();

  // Non-interactive tool-tips, triggered on a delayed hover. Auto-close when you roll-out of the PopOverRegion
  static PopOverRegion hover(
      {Key? key, required Widget child, required Widget popChild, Alignment? anchor, Alignment? popAnchor}) {
    return PopOverRegion(
        key: key,
        child: child,
        popChild: popChild,
        anchor: anchor,
        popAnchor: popAnchor,
        mode: PopOverRegionMode.Hover);
  }

  // Click to open/close. Use for interactive panels, or other elements that should close themselves
  static PopOverRegion click(
      {Key? key,
      required Widget child,
      required Widget popChild,
      Alignment? anchor,
      Alignment? popAnchor,
      bool? barrierDismissable,
      Color? barrierColor}) {
    return PopOverRegion(
      key: key,
      child: child,
      popChild: popChild,
      anchor: anchor,
      popAnchor: popAnchor,
      mode: PopOverRegionMode.ClickToToggle,
      barrierColor: barrierColor,
      barrierDismissable: barrierDismissable,
    );
  }

  static PopOverRegion hoverWithClick({
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

class PopOverRegionState extends State<PopOverRegion> {
  Timer? _timer;
  LayerLink _link = LayerLink();

  PopOverControllerState? _popContext;
  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(TextSpan(children: [
      TextSpan(text: "Hello"),
      TextSpan(text: "Bold", style: TextStyle(fontWeight: FontWeight.bold)),
    ]));
    Widget content;
    // If Hover, add a MouseRegion
    if (widget.mode == PopOverRegionMode.Hover) {
      content = MouseRegion(
        opaque: true,
        onEnter: (_) {
          _timer?.cancel();
          _timer = Timer.periodic(Duration(milliseconds: 400), (_) {
            safePrint("PopoverRegion: Show!");
            show();
            _timer?.cancel();
          });
        },
        onExit: (_) => hide(),
        child: widget.child,
      );
    } else {
      content = SimpleBtn(onPressed: show, child: widget.child);
    }
    return CompositedTransformTarget(link: _link, child: content);
  }

  @override
  void dispose() {
    hide();
    super.dispose();
  }

  void show() {
    if (mounted == false) {
      safePrint("PopoverRegion: Exiting early not mounted anymore");
      return;
    }
    safePrint("PopoverRegion: Sending notification...");
    ShowPopOverNotification(
            // Send context with the notification, so the Overlay can use it to send more messages in the future.
            context,
            // Provide a link so Flutter will auto-position for us
            _link,
            popChild: widget.popChild,
            anchor: widget.anchor ?? Alignment.bottomCenter,
            popAnchor: widget.popAnchor ?? Alignment.topCenter,
            // Don't use a barrier at all when using Hover mode
            useBarrier: widget.mode != PopOverRegionMode.Hover,
            barrierColor: widget.barrierColor ?? Colors.transparent,
            dismissOnBarrierClick: widget.barrierDismissable ?? true,
            // When a context catches this notification, it will callback.
            // We use this later to decide whether to ignore the exit event in HoverMode
            onContextHandled: _handleContextHandled)
        .dispatch(context);
  }

  void _handleContextHandled(PopOverControllerState value) => _popContext = value;

  void hide() {
    _timer?.cancel();
    // Don't close if the overlay is open, it means we've been replaced by a Click action.
    if (_popContext != null && _popContext!.isBarrierOpen == false) {
      _popContext?.closeCurrent();
    } else {
      // safePrint(
      //     "PopoverRegion: Hide on exit was skipped, context: $_popContext, isOpen: ${_popContext?.isBarrierOpen}");
    }
  }
}
