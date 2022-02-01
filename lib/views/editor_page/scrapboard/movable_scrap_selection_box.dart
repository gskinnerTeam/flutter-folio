// Provides btns (rotate, scale etc) and a border around the movable box.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/timed/debouncer.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/core_packages.dart';

class MovableScrapSelectionBox extends StatefulWidget {
  const MovableScrapSelectionBox(
      {Key? key,
      required this.child,
      required this.onZoomed,
      required this.onCornerDrag,
      required this.onDragEnded,
      required this.onRotateDrag,
      required this.btnSize,
      this.isVisible = false,
      required this.showControls})
      : super(key: key);
  final Widget child;
  final void Function(double delta) onZoomed;
  final void Function(Offset delta) onCornerDrag;
  final void Function(Offset delta) onRotateDrag;
  final void Function() onDragEnded;
  final bool isVisible;
  final double btnSize;
  final bool showControls;

  @override
  MovableScrapSelectionBoxState createState() => MovableScrapSelectionBoxState();
}

class MovableScrapSelectionBoxState extends State<MovableScrapSelectionBox> {
  final Debouncer _zoomDebounce = Debouncer(const Duration(milliseconds: 350));
  bool get isVisible => widget.isVisible;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          _handleScrollWheelEvent(signal);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          // Selection Outline
          if (isVisible) ...[
            Padding(
              padding: EdgeInsets.all(widget.btnSize),
              child: DecoratedContainer(borderColor: theme.accent1, borderWidth: 1.5, ignorePointer: true),
            ),
          ],

          // Scale Btn
          if (isVisible && widget.showControls) ...[
            Align(
              alignment: Alignment.bottomRight,
              child: FractionalTranslation(
                translation: const Offset(-.5, -.5),
                child: _Handle(
                  widget,
                  //icon: Icons.height,
                  onPanUpdate: (d) => widget.onCornerDrag(d),
                  onPanEnd: widget.onDragEnded,
                ),
              ),
            ),

            /// Rotation
            // Align(
            //   alignment: Alignment.topRight,
            //   child: FractionalTranslation(
            //     translation: Offset(-.5, .5),
            //     child: _Handle(
            //       widget,
            //       icon: Icons.rotate_right_outlined,
            //       onPanUpdate: (d) => widget.onRotateDrag(d),
            //       onPanEnd: widget.onDragEnded,
            //       //isCircular: true,
            //     ),
            //   ),
            // )
          ],
        ],
      ),
    );
  }

  void _handleScrollWheelEvent(PointerScrollEvent signal) {
    //print("${signal.scrollDelta.dy} @ ${TimeUtils.nowMillis}");
    double dir = signal.scrollDelta.dy > 0 ? -1 : 1;
    widget.onZoomed(dir * .1);
    _zoomDebounce.run(() => widget.onDragEnded.call());
  }
}

class _Handle extends StatelessWidget {
  const _Handle(this.widget, {Key? key, required this.onPanUpdate, required this.onPanEnd}) : super(key: key);
  final MovableScrapSelectionBox widget;
  final void Function(Offset delta) onPanUpdate;
  final void Function() onPanEnd;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (d) => onPanUpdate(d.delta),
      onPanEnd: (d) => onPanEnd(),
      child: SimpleBtn(
        onPressed: () {},
        child: SizedBox(
          width: widget.btnSize,
          height: widget.btnSize,
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: theme.accent1),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
