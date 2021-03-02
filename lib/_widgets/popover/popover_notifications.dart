import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/popover/popover_controller.dart';

/// //////////////////////////////////
/// POPOVER NOTIFICATION

/// Primary Notification for triggering events. You can use this direcly, but usually the [PopOverRegion] widget is sufficient.
class ShowPopOverNotification extends Notification {
  ShowPopOverNotification(
    this.context,
    this.link, {
    @required this.anchor,
    @required this.popAnchor,
    @required this.popChild,
    this.useBarrier = true,
    this.barrierColor = Colors.transparent,
    this.dismissOnBarrierClick = true,
    this.onContextHandled,
  });
  final BuildContext context;
  final LayerLink link;
  final Alignment anchor;
  final Alignment popAnchor;
  final Widget popChild;
  final bool useBarrier;
  final Color barrierColor;
  final bool dismissOnBarrierClick;
  final void Function(PopOverControllerState) onContextHandled;
}

// Dispatched from the PopOver Widget, so the PopOverContext can get the size of an arbitrary child Widget
class SizePopoverNotification extends Notification {
  SizePopoverNotification(this.size);
  final Size size;
}

// Anyone can send one of these up the tree to Close the current PopOver
class ClosePopoverNotification extends Notification {}
