import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'popover_notifications.dart';

/// //////////////////////////////////
/// POPOVER CONTEXT (ROOT)
/// Context listens for Notifications, and inserts/removes layers from the Overlay stack in response.
/// The context wraps the content in a
class PopOverController extends StatefulWidget {
  const PopOverController({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  PopOverControllerState createState() => PopOverControllerState();
}

class PopOverControllerState extends State<PopOverController> {
  OverlayEntry barrierOverlay;
  OverlayEntry mainContentOverlay;
  ValueNotifier<Size> _sizeNotifier = ValueNotifier(Size.zero);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _handleNotification,
      child: widget.child,
    );
  }

  bool get isBarrierOpen => barrierOverlay != null;

  void _closeOverlay() {
    _sizeNotifier?.value = null;
    barrierOverlay?.remove();
    mainContentOverlay?.remove();
    barrierOverlay = mainContentOverlay = null;
  }

  bool _handleNotification(Notification n) {
    // Close any open popovers
    if (n is ClosePopoverNotification) {
      _closeOverlay();
      return true;
    }
    // Show a new popover
    if (n is ShowPopOverNotification) {
      // Let the sender know who picked up, saves them a potential look up later.
      n.onContextHandled?.call(this);

      //Close existing popOver if one is open
      _closeOverlay();

      // Use Barrier? Hovers and Toasts don't user barriers, ClickOvers do
      if (n.useBarrier) {
        barrierOverlay = OverlayEntry(
          builder: (_) {
            return GestureDetector(
              onTap: n.dismissOnBarrierClick ? _closeOverlay : null,
              onPanStart: n.dismissOnBarrierClick ? (_) => _closeOverlay() : null,
              child: Container(color: n.barrierColor ?? Colors.transparent),
            );
          },
        );
        Overlay.of(n.context)?.insert(barrierOverlay);
      }

      /// Main Content Overlay
      mainContentOverlay = OverlayEntry(builder: (_) {
        // Wrap the child in a Listener, since it will technically be parented above us in the Stack (overlay items are above Navigator children)
        return NotificationListener(
          onNotification: _handleNotification,
          child: Material(
            type: MaterialType.transparency,
            // The overlay is wrapped in a VLB, so it can rebuild when the child calls us with a new size
            child: ValueListenableBuilder<Size>(
                valueListenable: _sizeNotifier,
                builder: (_, size, __) {
                  // Calculate the normalized offset, from a top-left starting point
                  // This means a top-left align is 0,0, and bottom-right is -1,-1 as we shift left and up
                  double ox = -(n.popAnchor.x + 1) / 2; // Normalize from 0-1
                  double oy = -(n.popAnchor.y + 1) / 2; // Normalize from 0-1
                  // Guard against null size
                  size ??= Size.zero;
                  print("BUILD OVERLAY: $size");
                  return CompositedTransformFollower(
                    offset: Offset(ox * size.width, oy * size.height),
                    targetAnchor: n.anchor,
                    link: n.link,
                    // An align is necessary to allow the content to size correctly
                    child: Align(
                      alignment: Alignment.topLeft,
                      // Hide the widget if the size is not value, we need 1 frame to size
                      child: Opacity(
                        opacity: size != Size.zero ? 1 : 0,
                        // Wrap content in a MeasureSize which sends us it's size via callback.
                        child: MeasureSize(onChange: _handlePopOverSized, child: FocusScope(child: n.popChild)),
                      ),
                    ),
                  );
                }),
          ),
        );
      });
      Overlay.of(n.context)?.insert(mainContentOverlay);
      return true;
    }
    return false;
  }

  void _handlePopOverSized(Size size) => scheduleMicrotask(() => _sizeNotifier.value = size);
}

/// Simple wrapper that measures itself and send the size in a callback or notification.
class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size _prevSize;
  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child.size;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({Key key, @required this.onChange, @required Widget child}) : super(key: key, child: child);
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}
