import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/core_packages.dart';

/// //////////////////////////////////
/// POPOVER CONTEXT (ROOT)
/// Context listens for Notifications, and inserts/removes layers from the Overlay stack in response.
/// The context wraps the content in a
class AnchoredPopups extends StatefulWidget {
  const AnchoredPopups({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  AnchoredPopupsController createState() => AnchoredPopupsController();

  static AnchoredPopupsController? of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<_InheritedPopupOverlay>();
    if (w == null) print("[AnchoredPopups] WARNING: No AnchoredPopup was found.");
    return w == null ? null : w.state;
  }
}

class AnchoredPopupsController extends State<AnchoredPopups> {
  OverlayEntry? barrierOverlay;
  OverlayEntry? mainContentOverlay;
  ValueNotifier<Size?> _sizeNotifier = ValueNotifier(Size.zero);
  PopupConfig? _currentPopupConfig;
  PopupConfig? get currentPopup => _currentPopupConfig;

  @override
  Widget build(BuildContext context) {
    final config = _currentPopupConfig;
    RenderBox? rb = config?.context.findRenderObject() as RenderBox?;
    Size size = rb?.size ?? Size.zero;
    Offset anchoredWidgetPos = rb?.localToGlobal(Offset(
          size.width / 2 + (config?.anchor.x ?? 0) * size.width / 2,
          size.height / 2 + (config?.anchor.y ?? 0) * size.height / 2,
        )) ??
        Offset.zero;
    return _InheritedPopupOverlay(
        state: this,
        child: Stack(
          children: [
            widget.child,
            if (config != null) ...[
              // Barrier
              if (config.useBarrier) ...[
                GestureDetector(
                    onTap: config.dismissOnBarrierClick ? () => hide() : null,
                    child: Container(color: config.barrierColor)),
              ],
              // Pop child
              Transform.translate(
                offset: anchoredWidgetPos,
                child: FractionalTranslation(
                  translation: (((Offset(
                    // PopAnchor has values of -1,-1, to indicate topLeft, and 1,1 to indicate bottomRight anchor position.
                    // This means when alignment is (-1,-1) we need a offset of (0,0) which is the default top-left alignment
                    // When alignment is (1,1) we need an offset of (-1,-1) which will shift on both x and y axis, for a bottom-right anchor position.
                    // This can be expressed with: (.5 - value/2) - 1
                    ((.5 - (config.popAnchor.x / 2)) - 1),
                    ((.5 - (config.popAnchor.y / 2)) - 1),
                  )))),
                  child: config.popChild,
                ),
              ),
            ],
          ],
        ));
  }

  bool get isBarrierOpen => barrierOverlay != null;

  void hide() {
    print("Close current");
    setState(() => _currentPopupConfig = null);
    _sizeNotifier.value = null;
    barrierOverlay?.remove();
    mainContentOverlay?.remove();
    barrierOverlay = mainContentOverlay = null;
  }

  void show(
    BuildContext context, {
    bool useBarrier = true,
    bool dismissOnBarrierClick = true,
    Color barrierColor = Colors.transparent,
    required Alignment anchor,
    required Alignment popAnchor,
    required Widget popChild,
  }) {
    setState(() {
      _currentPopupConfig = PopupConfig(context,
          anchor: anchor,
          popAnchor: popAnchor,
          popChild: popChild,
          useBarrier: useBarrier,
          barrierColor: barrierColor,
          dismissOnBarrierClick: dismissOnBarrierClick);
    });

    //
    // // Use Barrier? Hovers and Toasts don't user barriers, ClickOvers do
    // if (useBarrier) {
    //   OverlayEntry b = OverlayEntry(
    //     builder: (_) {
    //       return GestureDetector(
    //         onTap: dismissOnBarrierClick ? closeCurrent : null,
    //         onPanStart: dismissOnBarrierClick ? (_) => closeCurrent() : null,
    //         child: Container(color: barrierColor),
    //       );
    //     },
    //   );
    //   Overlay.of(context)?.insert(b);
    //   barrierOverlay = b;
    // }
    //
    // /// Main Content Overlay
    // OverlayEntry content = OverlayEntry(builder: (_) {
    //   // Wrap the child in a Listener, since it will technically be parented above us in the Stack (overlay items are above Navigator children)
    //   return Material(
    //     type: MaterialType.transparency,
    //     // The overlay is wrapped in a VLB, so it can rebuild when the child child size is measured
    //     child: ValueListenableBuilder<Size?>(
    //         valueListenable: _sizeNotifier,
    //         builder: (_, size, __) {
    //           // Guard against null size
    //           size ??= Size(0, 0);
    //           // Calculate the normalized offset, from a top-left starting point
    //           // This means a top-left align is 0,0, and bottom-right is -1,-1 as we shift left and up
    //           double ox = -(popAnchor.x + 1) / 2; // Normalize
    //           double oy = -(popAnchor.y + 1) / 2; // Normalize
    //           return CompositedTransformFollower(
    //             offset: Offset(ox * size.width, oy * size.height),
    //             targetAnchor: anchor,
    //             link: link,
    //             // An align is necessary to allow the content to size correctly
    //             child: Align(
    //               alignment: Alignment.topLeft,
    //               // Hide the widget if the size is not value, we need 1 frame to size
    //               child: Opacity(
    //                 opacity: size != Size.zero ? 1 : 0,
    //                 // Wrap content in a MeasureSize which sends us it's size via callback.
    //                 child: MeasureSize(onChange: _handlePopOverSized, child: FocusScope(child: popChild)),
    //               ),
    //             ),
    //           );
    //         }),
    //   );
    // });
    // safePrint("PopoverController: insert overlay");
    // Overlay.of(context)?.insert(content);
    // mainContentOverlay = content;
  }
}

/// Simple wrapper that measures itself and send the size in a callback or notification.
class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size? _prevSize;
  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance?.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({Key? key, required this.onChange, required Widget child}) : super(key: key, child: child);
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}

/// InheritedWidget boilerplate
class _InheritedPopupOverlay extends InheritedWidget {
  _InheritedPopupOverlay({Key? key, required Widget child, required this.state}) : super(key: key, child: child);

  final AnchoredPopupsController state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class PopupConfig {
  PopupConfig(this.context,
      {this.useBarrier = true,
      this.dismissOnBarrierClick = true,
      this.barrierColor = Colors.transparent,
      required this.anchor,
      required this.popAnchor,
      required this.popChild});

  final BuildContext context;
  final bool useBarrier;
  final bool dismissOnBarrierClick;
  final Color barrierColor;
  final Alignment anchor;
  final Alignment popAnchor;
  final Widget popChild;
}
